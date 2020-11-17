function Nei8 = Nei(labelMatrix)
[nrows,ncols]=size(labelMatrix);

% Boundaries surrounded by zeros so neighbours can be checked equally
% along the matrix
newLabelMatrix = zeros(nrows+2,ncols+2);
newLabelMatrix(2:end-1,2:end-1) = labelMatrix;

Nei8 = zeros(nrows*ncols,8); % 8 neighbours per row, 256x256 rows
X = newLabelMatrix(:); % avoid loop indentation
[n,m] = size(newLabelMatrix);
neiIdx = 1;
for idx=n+2:n*m-(n+2)
    if X(idx)~=0
        Nei8(neiIdx,:) = [X(idx-n-1),...
                         X(idx-n),...
                         X(idx-n+1),...
                         X(idx-1),...
                         X(idx+1),...
                         X(idx+n-1),...
                         X(idx+n),...
                         X(idx+n+1)];
        neiIdx = neiIdx+1;
    end
end
end

