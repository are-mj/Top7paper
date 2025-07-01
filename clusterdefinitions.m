function [cl1,cl2,cl3,outliers,clustershapes] = clusterdefinitions(Trip)
% Defining clusters for Top7  
% Input: Trip: Results table for rips
% Output: Clusters: 3 by height(Trip) logical array
%         Clusters(i,j) = true if rip no. i is in cluster j
%         clustersahpes: polyshape objects for plotting the cluster extent
%         in a Force  vs Delta x scatter plot
% NOTE:  If very few rips (e.g for slow pulling speed), clusters 2 and 3
%        is often combined to 1
%        Rips that are not in any cluster are denoted outliers:
%          outliers = ~any(clusters,2)
% The clusters are defined as rectangles in a Δx - Force scatter plot
% The borders of the ractangles are adjusted so that the Bell model
% root-mean-square deviation between observation and fitted model is close
% to a minimum.

  forcegrid = [6,11,16,55];
  dxgrid = [10,20,26];
  cl1 = Trip.Deltax > dxgrid(2) & Trip.Deltax < dxgrid(3) & ...
        Trip.Force > forcegrid(3) & Trip.Force < forcegrid(4);
  cl2 = Trip.Deltax > dxgrid(1) & Trip.Deltax < dxgrid(2) & ...
        Trip.Force > forcegrid(2) & Trip.Force < forcegrid(3);
  cl3 = Trip.Deltax > dxgrid(1) & Trip.Deltax < dxgrid(2) & ...
        Trip.Force > forcegrid(1) & Trip.Force < forcegrid(2);
  outliers = ~(cl1|cl2|cl3);

  clustershapes(1) = polyshape(dxgrid([2,3,3,2,2]),forcegrid([3,3,4,4,3]));
  clustershapes(2) = polyshape(dxgrid([1,2,2,1,1]),forcegrid([2,2,3,3,2]));
  clustershapes(3) = polyshape(dxgrid([1,2,2,1,1]),forcegrid([1,1,2,2,1]));
