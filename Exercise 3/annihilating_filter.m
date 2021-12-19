function [h, tk, ak] = annihilating_filter(tau)
    
    K = 2;
    N = length(tau) - 1;
   

    tau_matrix = zeros(N-K+1, K);
    for j = K:N
        current_row = zeros(1, K);
        for i = 1:K
            current_row(i) = tau(j-i+1);
        end
        tau_matrix(j-K+1,:) = current_row;
    end


    tau_vector = zeros(N-K+1, 1);
    for i = 1:length(tau_vector)
        tau_vector(i) = - tau(K+i);
    end

    
    h = zeros(K+1, 1);
    h(1) = 1;
    h(2:end) = tau_matrix \ tau_vector;
    
    tk = sort(roots(h));
    

    tk_matrix = zeros(K, length(tk));
    for i = 0:K-1
        current_row = zeros(1, length(tk));
        for element = 1:length(tk)
            current_row(element) = tk(element) ^ i;
        end
        tk_matrix(i+1,:) = current_row;
    end


    tau_vector_2 = zeros(K, 1);
    for j = 1:K
        tau_vector_2(j, 1) = tau(j);
    end


    ak = tk_matrix \ tau_vector_2;

end