function Ep=pairwiseTerm(labelMatrix, class_number)
    % Pairwise term 
    labels = labelMatrix(:);
    n = size(labels,1);
    Nei8 = Nei(labelMatrix);
    Ep=zeros(n,class_number);
    for k=1:class_number 
        Ep(:,k) = sum(Nei8~=k,2);
    end

end