function insert_result()
    insert_rank_query = "INSERT INTO airbnb_rank SET created_at = NOW()"
    insert_rank_statement = DBInterface.prepare(conn, insert_rank_query)
    insert_rank = DBInterface.execute(insert_rank_statement)

    airbnb_rank_id = DBInterface.lastrowid(insert_rank)

    retrieve_id_query = "SELECT id AS `airbnb_id` FROM airbnb ORDER BY id"
    retrieve_id_statement = DBInterface.prepare(conn, retrieve_id_query)
    retrieve_id = DBInterface.execute(retrieve_id_statement)

    insert_data = []

    for (index, retrieved) in enumerate(retrieve_id)
        airbnb_id = retrieved.airbnb_id
        rank = topsis_result["rank"][index]
        score = topsis_result["relative_closenesses"][index]

        push!(insert_data, "($airbnb_rank_id, $airbnb_id, $rank, $score)")
    end

    insert_rank_detail_query = "INSERT INTO airbnb_rank_detail (airbnb_rank_id, airbnb_id, `rank`, score) VALUES " * join(insert_data, ",")
    insert_rank_detail_statement = DBInterface.prepare(conn, insert_rank_detail_query)
    DBInterface.execute(insert_rank_detail_statement)
end