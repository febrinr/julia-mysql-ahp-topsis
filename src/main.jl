@time begin

include("ahp.jl")
include("connection.jl")
include("result.jl")
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

retrieve_query = "SELECT cleanliness_rating AS `1`, guest_satisfaction_overall AS `2`, bedrooms AS `3` FROM airbnb ORDER BY id"
retrieve_statement = DBInterface.prepare(conn, retrieve_query)
decision_matrix = DBInterface.execute(retrieve_statement)

topsis_result = topsis()

insert_result()

DBInterface.close!(conn)

end
