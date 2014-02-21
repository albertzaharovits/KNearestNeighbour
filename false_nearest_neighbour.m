function embedm=false_nearest_neighbour(x,max_dim,rel_thr,err_thr,p)

% Usage: This function  calculates CORRECTED false nearest neighbour.
 
% Input 
%   x:  time series column vector
%   max_dim: maximum value of embedding dimension.
%	rel_thr: distance between points when they are no longer neighbours
%	err_thr: if the distance to the nearest neighbour becomes smaller 
%				than the standard deviation of the data divided by the threshold, the points are not neighbours
% Output
%   embedm: value for embedding dimension.


% default value for relative error threshold (relative to state value)
if rel_thr <= 0
	rel_thr = 15;
end

% default value for relative error threshold (relative to standard error deviation)
if err_thr <= 0
	err_thr = 2;
end

% default percentage value ( maximum percentage of false neighbours )
if (p<=0) || (p>1)
	p = 0.1;
end

x=x(:);

%Embedding matrix (concatenated lagged column time series)
EM=lagmatrix(x,0:max_dim-1);
%EM after nan elimination.
EM=EM(max_dim:end,:);

[xr,xc]=size(x);
sigmax=std(x);

[EMr EMc]=size(EM);

embedm=[];

for k=1:EMc
	% false nearest neighbours list
    fnn1=[];
    fnn2=[];
	
	% EM(:,1:k)' is the phase matrix for k embedding dimensions (delay space)
	% dist returns the euclidean distance matrix between each phases
    D=dist(EM(:,1:k)');
   
    for i=1:EMr-max_dim-k
       
		d1=min(D(i,1:i-1));
		d2=min(D(i,i+1:end));
		% minimum inter-phase distance
		[dm, pos]=min([d1;d2]);
		% position of the minimum phase distance
		%pos=find(D(i,1:end)==dm);
		if dm>0
			if pos+max_dim+k-1<xr 
				% concatenate inter-state errors
				fnn1=[fnn1;abs(x(i+max_dim+k-1,1)-x(pos+max_dim+k-1,1))/dm];
				% corrected false nearest neighbour:
				%  If the distance to the nearest neighbour becomes smaller than the standard deviation of the data divided by the threshold, the point is omitted
				fnn2=[fnn2;abs(x(i+max_dim+k-1,1)-x(pos+max_dim+k-1,1))/sigmax];
			end 
        end
    end
   
	nrel_thr=length(find(fnn1>rel_thr));
    %len_fnn = length(fnn1)
	nerr_thr=length(find(fnn2>err_thr));
	% black magic
	if (nrel_thr/length(fnn1))<p && (nerr_thr/length(fnn2))<p
		embedm=k;
		break
	end
	
end
