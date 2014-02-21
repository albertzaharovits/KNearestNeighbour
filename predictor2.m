% repeatedly calls predictor1, and appends result to series
function v = predictor2(  series, embdm, k, count )

series=series(:);
v=[];
for i=1:count
    % get new predicted value
    p = predictor1( series, embdm, k);
    % append to output vector
    v = [ v, p];
    % append to series
    series = [ p; series];
end

end

