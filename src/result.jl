function insert_result(alt_group, conn, ranks, performance_scores, rank_log_id)
    insert_data = generate_insert_value_query(alt_group, conn, ranks, performance_scores, rank_log_id)

    chunked = collect(Iterators.partition(insert_data, 100000))

    for (batch, chunk) in enumerate(chunked)
        insert_rank_result_query = "
            INSERT INTO
                rank_result
            (
                rank_log_id,
                alternative_id,
                `rank`,
                score,
                estimation_year
            )
            VALUES " * join(chunk, ",")
            
        insert_rank_result_statement = DBInterface.prepare(conn, insert_rank_result_query)
        DBInterface.execute(insert_rank_result_statement)
        DBInterface.close!(insert_rank_result_statement)

        println(string("Insert result batch: ", batch))
    end
end

function generate_insert_value_query(alt_group, conn, ranks, performance_scores, rank_log_id)
    this_year = year(today())
    quota = get_quota(alt_group)
    insert_data = []

    alternatives = get_alternatives_id(alt_group, conn)

    for (index, row_data) in enumerate(alternatives)
        alternative_id = row_data.alternative_id
        rank = ranks[index]
        score = performance_scores[index]
        estimation_year = this_year + div(rank, quota, RoundUp)

        # println("id: $alternative_id")

        if index % 50000 == 0
            println(index)
        end

        push!(insert_data, "($rank_log_id, $alternative_id, $rank, $score, $estimation_year)")
    end
    
    println()

    return insert_data
end

function get_alternatives_id(alt_group, conn)
    if ENV["APP_ENV"] == "test"
        query = "
        SELECT
            id AS `alternative_id`
        FROM
            alternative
        ORDER BY id"
    elseif ENV["APP_ENV"] == "hajj"
        query = "
        SELECT
            id AS `alternative_id`
        FROM
            alternative
        WHERE
            (id_provinsi = '$alt_group' OR 'all' = '$alt_group')
        ORDER BY id"
    end
    
    statement = DBInterface.prepare(conn, query)
    alternatives = DBInterface.execute(statement)
    
    return alternatives
end

function get_quota(alt_group)
    number_of_quota = 0

    if ENV["APP_ENV"] == "test"
        number_of_quota = 4
    elseif ENV["APP_ENV"] == "hajj"
        query = "
            SELECT
                (SUM(kuota) + SUM(kuota_lansia)) AS number_or_quota
            FROM
                kuota_tahun_provinsi
            WHERE
                id_kuota_tahun = (
                    SELECT id FROM kuota_tahun ORDER BY tahun DESC LIMIT 1
                )
                AND (id_provinsi = '$alt_group' OR 'all' = '$alt_group')"
        
        statement = DBInterface.prepare(conn, query)
        quota = DBInterface.execute(statement)

        for row_data in quota
            number_of_quota = row_data.number_or_quota
        end
    end

    return number_of_quota
end
