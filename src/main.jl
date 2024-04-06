@time begin

include("ahp.jl")
include("connection.jl")
include("topsis.jl")

comparison_matrix = [
    [1, 1, 3],
    [1, 1, 5],
    [1/3, 1/5, 1]
]

number_of_criteria = length(comparison_matrix[1])

ahp_result = ahp()

criteria_type = ["benefit", "benefit", "benefit"]
weight = ahp_result["priority_vector"]

# sql = "SELECT cleanliness_rating AS `1`, guest_satisfaction_overall AS `2`, bedrooms AS `3` FROM airbnb;"
# sql_result = DBInterface.execute(conn, sql)
# decision_matrix = []

# for result_row in sql_result
#     row = []

#     for score in result_row
#         push!(row, score)
#     end

#     push!(decision_matrix, row)
# end

sql = "SELECT cleanliness_rating AS `1`, guest_satisfaction_overall AS `2`, bedrooms AS `3` FROM airbnb;"
statement = DBInterface.prepare(conn, sql)
decision_matrix = DBInterface.execute(statement)

topsis_result = topsis()

end
