function Eu=unaryTerm(image, labelMatrix, class_number)
    % mu and sigma for each of the classes
    mu(1)=mean(image(labelMatrix==1)); 
    mu(2)=mean(image(labelMatrix==2)); 
    sigma(1)=std(image(labelMatrix==1));
    sigma(2)=std(image(labelMatrix==2));

    % Unary term
    Y = image(:);
    n=size(Y,1); 
    Eu=zeros(n,class_number);
    
    for k=1:class_number
        diff_k=Y-repmat(mu(k),[n,1]);
        Eu(:,k)=sum(diff_k*inv(sigma(k)).*diff_k,2)+log(det(sigma(k)));
    end
end