function FigS15

  load Tables TRIPTop7Top7 TRIPTop7BSA TRIPTop7FOXP1
  load Tables TZIPTop7Top7 TZIPTop7BSA TZIPTop7FOXP1

  figure('Name','FigS15');
  tl = tiledlayout(1,3,"TileSpacing","compact");
  ripedges = 1:2:56;
  zipedges = 0.5:20.5;
  nexttile
    Nrip = histcounts(TRIPTop7Top7.Force,ripedges);
    prip = Nrip/sum(Nrip);  % Probability density
    bar(midpoints(ripedges),prip,1);
    Nzip = histcounts(TZIPTop7Top7.Force,zipedges);
    pzip = Nzip/sum(Nzip);  % Probability density
    hold on
    bar(midpoints(zipedges),pzip,1,'FaceAlpha',0.5);
    xlabel('Force (pN)');
    ylabel('Probability density (pN)')
    title('Top7 with Top7 in solution')
    legend('Unfolding','Refolding')
  nexttile
    Nrip = histcounts(TRIPTop7FOXP1.Force,ripedges);
    prip = Nrip/sum(Nrip);  % Probability density
    bar(midpoints(ripedges),prip,1);
    Nzip = histcounts(TZIPTop7FOXP1.Force,zipedges);
    pzip = Nzip/sum(Nzip);  % Probability density
    hold on
    bar(midpoints(zipedges),pzip,1,'FaceAlpha',0.5);
    xlabel('Force (pN)');
    ylabel('Probability density (pN)')   
    title('Top7 with FOXP1 in solution')
  nexttile
    Nrip = histcounts(TRIPTop7BSA.Force,ripedges);
    prip = Nrip/sum(Nrip);  % Probability density
    bar(midpoints(ripedges),prip,1);
    Nzip = histcounts(TZIPTop7BSA.Force,zipedges);
    pzip = Nzip/sum(Nzip);  % Probability density
    hold on
    bar(midpoints(zipedges),pzip,1,'FaceAlpha',0.5);
    xlabel('Force (pN)');
    ylabel('Probability density (pN)')   
    title('Top7 with BSA in solution')  

    set(gcf,"Position",[180,264,1051,250]);

end
    