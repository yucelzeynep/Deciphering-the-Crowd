ccc

numberOfHumans = 0;
numberOfWheelchair = 0;
numberOfShoppingcart = 0;
numberOfBabycart= 0;

for i = 1:15
    part_number = i;

    load(['..\data\labels\labels', num2str(part_number)]);

    numberOfHumans = ...
        numberOfHumans + sum(labels(:,2)==1);
    
    numberOfWheelchair = ...
        numberOfWheelchair + sum(labels(:,2)==2);
    
    numberOfShoppingcart =...
        numberOfShoppingcart + sum(labels(:,2)==3);
    
    numberOfBabycart =...
        numberOfBabycart + sum(labels(:,2)==4) + sum(labels(:,2)==5);

    % load ids which overlap in time
end

fprintf('In this dataset, there are the following entities\n');
fprintf('Humans: %i \n', numberOfHumans);
fprintf('Wheelchair: %i \n', numberOfWheelchair);
fprintf('Shoppingcart: %i \n', numberOfShoppingcart);
fprintf('Babycart: %i \n', numberOfBabycart);


fprintf('Total number of entities: %i\n', numberOfHumans + numberOfWheelchair + numberOfShoppingcart + numberOfBabycart);

