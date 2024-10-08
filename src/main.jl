using Dates
using DotEnv
using MySQL
using StatsBase

DotEnv.load!()

include("connection.jl")
include("rank_log.jl")
include("criteria.jl")
include("ahp.jl")
include("topsis_decision_matrix.jl")
include("topsis.jl")
include("result.jl")

function main(conn)
        
    alt_group = ENV["ALT_GROUP"]

    rank_log_id = insert_rank_log(conn)

    println("Calculating AHP...")
    println()

    priority_vector, consistency_ratio = ahp(comparison_matrix, number_of_criteria)

    println("Number of criteria: $number_of_criteria")
    println()
    println("Priority Vector: $priority_vector")
    println()

    if consistency_ratio > 0.10
        println("Consistency Ratio value: $consistency_ratio is not acceptable")

        return
    end

    println("Consistency Ratio value: $consistency_ratio is acceptable")
    println()

    number_of_alternatives = get_number_of_alternatives(alt_group, conn)

    println("Number of alternatives: $number_of_alternatives")
    println()
    println("Calculating TOPSIS...")
    println()

    decision_matrix = get_topsis_decision_matrix(alt_group, conn, number_of_alternatives, number_of_criteria)
    performance_scores, ranks = topsis(decision_matrix, priority_vector, number_of_alternatives)

    insert_result(alt_group, conn, ranks, performance_scores, rank_log_id)

    return rank_log_id, number_of_criteria, priority_vector, consistency_ratio, number_of_alternatives
end

timed_stats = @timed rank_log_id, number_of_criteria, priority_vector, consistency_ratio, number_of_alternatives = main(conn)

println()
println(string("Elapsde Time: ", timed_stats.time), " seconds")
println(string("Total Bytes Allocated: ", timed_stats.bytes), " bytes")
println(string("Garbage Collection Time: ", timed_stats.gctime), " seconds")

update_rank_log(conn, timed_stats.time, timed_stats.bytes, timed_stats.gctime, rank_log_id)

println()
println("Number of criteria: $number_of_criteria")
println()
println("Priority Vector: $priority_vector")
println()
println("Consistency Ratio value: $consistency_ratio is acceptable")
println()
println("Number of alternatives: $number_of_alternatives")
println()

DBInterface.close!(conn)
