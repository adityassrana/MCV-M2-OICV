function Eu=unaryTerm(image, labelMatrix, class_number)
    % Unary term
    Y = image(:);
    n=size(Y,1); 
    Eu=zeros(n,class_number);
    
    for k=1:class_number
        % mu and sigma for each of the classes
        mu(k)=mean(image(labelMatrix==k)); 
        sigma(k)=std(image(labelMatrix==k));
    
        diff_k=Y-repmat(mu(k),[n,1]);
        Eu(:,k)=sum(diff_k*inv(sigma(k)).*diff_k,2)+log(det(sigma(k)));
    end
end