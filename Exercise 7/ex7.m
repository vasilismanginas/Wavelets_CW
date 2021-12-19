
tau = [2.994042897218497e+03 2.096993713307506e+06 1.525803001151629e+09 1.144416297002504e+12 8.771131716063866e+14];

K = 2;
N = length(tau) - 1;
cadzow = false;


S = zeros(N-K, K+1);
for j = K:N-1
    current_row = zeros(1, K+1);
    for i = 0:K
        current_row(i+1) = tau(j-i+1);
    end
    S(j-K+1,:) = current_row;
end


if cadzow
    iterations = 10;
    smallest_dimension = min(size(S));

    for iter = 1:iterations
        [U, L, V] = svd(S);
    
        for index = K+1:smallest_dimension
            L(index,index) = 0;
        end
        
        S = U * L * V';
    
        diagonal = diag(S);
        average = mean(diagonal);
    
        for index = 1:smallest_dimension
            S(index,index) = average;
        end
    end
end


[U, L, V] = svd(S);
h = V(:, end);

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

tkTLS = round(tk) + 1
akTLS = tk_matrix \ tau_vector_2

[h, tk, ak] = annihilating_filter(tau)