% predicts the next value following in the series
% embdm length lagged vectors
% k nearest negihbours count
function v = predictor1( series, embdm, k )

    series = series(:);
    % current lagged vector
    current = series(end-embdm+1:end);
    n = length(series);
    lagged = lagmatrix(series, 0:(n-embdm-1))
    % remove NaNs from lagged matrix
    lagged = lagged((n-embdm):end,1:end);
    % all lagged vectors of length embdm
    lagged = lagged(1:(end-1),:);
    % next value following corresponding lagged vector
    heads = lagged(end,:);
    
    % euclidean distance vector
    D = dist(current', lagged);
   
    % predicted value is the weighted arithmetic mean of the heads
    % of the lagged vectors
    inv_dist = 0;
    predicted_value = 0;
    for i=1:k
        [val, pos] = min(D);
        inv_dist = inv_dist + 1.0/val;
        predicted_value = predicted_value + heads(pos)/val;
        % split out the min distance
        D = [D(1:(pos-1)) , D((pos+1):end)];
        heads = [heads(1:(pos-1)), heads((pos+1):end)];
    end
    
    % weighted arithmetic mean
    v=predicted_value/inv_dist;
end

