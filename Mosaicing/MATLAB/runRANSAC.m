function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
%RUNRANSAC
    num_pts = size(Xs, 1);
    pts_id = 1:num_pts;
    inliers_id = [];
    
    for i=1:ransac_n
        % ---------------------------
        % START ADDING YOUR CODE HERE
        % ---------------------------
        s = size(Xs,1); 
        rand_ind = randi(s,4,1); 
        rand_xs = Xs (rand_ind,:); 
        rand_xd = Xd (rand_ind,:);
        
        height = computeHomography(rand_xs, rand_xd);
        
        Xd_temp = applyHomography(height,Xs);
        
        dist = ((Xd(:,1) - Xd_temp(:,1)).^2 + (Xd(:,2) - Xd_temp(:,2)).^2).^(0.5);
        
        id = find (dist < eps);
        if length(id) > M 
            M = length(id);
            H = height;
            inliers_id=id;
        end
    end
        % ---------------------------
        % END ADDING YOUR CODE HERE
        % ---------------------------    
end
