function insert_rank_log(conn)
    query = "INSERT INTO rank_log SET created_at = NOW()"
    statement = DBInterface.prepare(conn, query)
    insert = DBInterface.execute(statement)

    rank_log_id = DBInterface.lastrowid(insert)

    return rank_log_id
end

function update_rank_log(conn, elapsed_time, bytes_allocated, gc_time, rank_log_id)
    query = "
        UPDATE
            rank_log
        SET
            finished_at = NOW(),
            elapsed_time_seconds = '$elapsed_time',
            bytes_allocated = '$bytes_allocated',
            gc_time_seconds = '$gc_time'
        WHERE
            id = $rank_log_id"
    
    statement = DBInterface.prepare(conn, query)
    DBInterface.execute(statement)
end
