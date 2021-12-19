function [h, tk, ak] = TLS(moments, cadzow, N, K)

    S = zeros(N-K, K+1);
    for j = K:N-1
        current_row = zeros(1, K+1);
        for i = 0:K
            current_row(i+1) = moments(j-i+1);
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

    [~, ~, V] = svd(S);
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
    
    
    moments_vector_2 = zeros(K, 1);
    for j = 1:K
        moments_vector_2(j, 1) = moments(j);
    end
    
    
    ak = tk_matrix \ moments_vector_2;
end