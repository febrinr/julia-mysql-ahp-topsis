if ENV["APP_ENV"] == "test"
    criteria = ["Luas" "Luas Parkir" "Harga Sewa" "Akses" "Persaingan"]
    criteria_type = ["cost" "benefit" "benefit" "benefit" "benefit"] # cost|benefit

    comparison_matrix = [
        1   1   1/3 1/3 2
        1   1   1/3 1/5 1/2
        3   3   1   2   3
        3   5   1/2 1   3
        1/2 2   1/3 1/3 1
    ]
elseif ENV["APP_ENV"] == "hajj"
    # criteria = ["Status Lansia" "Tanggal Lahir" "Tanggal Pendaftaran" "Status Haji" "Status Pasangan" "Status Pendamping Lansia"]
    # criteria_type = ["benefit" "benefit" "benefit" "cost" "benefit" "benefit"] # cost|benefit

    # comparison_matrix = [
    #     1   3   3   9   9   9
    #     1/3 1   1/3 7   5   5
    #     1/3 3   1   7   5   5
    #     1/9 1/7 1/7 1   1/3 1/3
    #     1/9 1/5 1/5 3   1   1
    #     1/9 1/5 1/5 3   1   1
    # ]
    
    criteria = ["Status Lansia" "Tanggal Lahir" "Tanggal Pendaftaran" "Status Haji"]
    criteria_type = ["benefit" "benefit" "benefit" "cost"] # cost|benefit

    comparison_matrix = [
        1   5   3   9
        1/5 1   1/3 5 
        1/3 3   1   7
        1/9 1/5 1/7 1
    ]
end


number_of_criteria = size(criteria, 2)