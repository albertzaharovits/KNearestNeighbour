function err = mean_square_error( values, predicted )

values = values(:);
predicted = predicted(:);
err = sum((values - predicted).^2)/length(values);

end

