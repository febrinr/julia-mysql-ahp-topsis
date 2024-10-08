function get_topsis_decision_matrix(alt_group, conn, number_of_alternatives, number_of_criteria)
    if ENV["APP_ENV"] == "test"
        query = "
            SELECT
                criteria1 AS `1`,
                criteria2 AS `2`,
                criteria3 AS `3`,
                criteria4 AS `4`,
                criteria5 AS `5`
            FROM
                alternative
            ORDER BY id"
    elseif ENV["APP_ENV"] == "hajj"
        query = "
            SELECT
                IF((TIMESTAMPDIFF(YEAR,tanggal_lahir,CURDATE()) > 65),1,0) AS `1`, -- status_lansia
                (TO_DAYS(CURDATE()) - TO_DAYS(tanggal_lahir)) AS `2`, -- usia_hari
                (TO_DAYS(CURDATE()) - TO_DAYS(tanggal_daftar)) AS `3`, -- lama_daftar_hari
                status_haji AS `4` -- status_lansia
            FROM
                alternative
            WHERE
                (id_provinsi = '$alt_group' OR 'all' = '$alt_group')
            ORDER BY id"
    end

    statement = DBInterface.prepare(conn, query)
    data = DBInterface.execute(statement)

    decision_matrix = zeros(Float64, number_of_alternatives, number_of_criteria)

    for (row_number, row_data) in enumerate(data)
        for (column_number, data) in enumerate(row_data)
            decision_matrix[row_number, column_number] = data
        end
    end

    return decision_matrix
end

function get_number_of_alternatives(alt_group, conn)
    if ENV["APP_ENV"] == "test"
        query = "SELECT COUNT(id) AS number_or_alternatives FROM alternative"
    elseif ENV["APP_ENV"] == "hajj"
        query = "
            SELECT
                COUNT(id) AS number_or_alternatives
            FROM
                alternative
            WHERE
                (id_provinsi = '$alt_group' OR 'all' = '$alt_group')"
    end

    statement = DBInterface.prepare(conn, query)
    count_alternatives = DBInterface.execute(statement)

    number_of_alternatives = 0

    for row_data in count_alternatives
        number_of_alternatives = row_data.number_or_alternatives
    end

    return number_of_alternatives
end
