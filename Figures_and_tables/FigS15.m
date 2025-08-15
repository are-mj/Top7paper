function FigS15_v2

  load Tables TRIPTop7Top7 TRIPTop7BSA TRIPTop7FOXP1
  load Tables TZIPTop7Top7 TZIPTop7BSA TZIPTop7FOXP1

  figure('Name','FigS15');
  tl = tiledlayout(2,3,"TileSpacing","compact");
  dprip = 2;
  dpzip = 0.5;
  ripedges = 1:2:56;
  zipedges = 0.5:0.5:15.5;
  nexttile
    Nrip = histcounts(TRIPTop7Top7.Force,ripedges);
    prip = Nrip/sum(Nrip)/dprip;  % Probability density
    bar(midpoints(ripedges),prip,1,'FaceAlpha',0.5);
    ylabel('Rip')
    title('Top7 with Top7 in solution')
    xlabel('Force (pN)');
    ylim([0,0.125]);
    text(42,0.055,sprintf('n = %5d',sum(Nrip)))
    ylim([0,0.065])
  nexttile
    Nrip = histcounts(TRIPTop7FOXP1.Force,ripedges);
    prip = Nrip/sum(Nrip)/dprip;  % Probability density
    bar(midpoints(ripedges),prip,1,'FaceAlpha',0.5);
    xlabel('Force (pN)'); 
    title('Top7 with FOXP1 in solution')
    ylim([0,0.125]);
    text(42,0.055,sprintf('n = %5d',sum(Nrip)))
    ylim([0,0.065])
  nexttile
    Nrip = histcounts(TRIPTop7BSA.Force,ripedges);
    prip = Nrip/sum(Nrip)/dprip;  % Probability density
    bar(midpoints(ripedges),prip,1,'FaceAlpha',0.5);
    xlabel('Force (pN)');
    title('Top7 with BSA in solution')  
    ylim([0,0.125]);
    text(42,0.055,sprintf('n = %5d',sum(Nrip)))  
    ylim([0,0.065])

  nexttile
    Nzip = histcounts(TZIPTop7Top7.Force,zipedges);
    pzip = Nzip/sum(Nzip)/dpzip;  % Probability density
    bar(midpoints(zipedges),pzip,1,'FaceAlpha',0.5);
    ylabel('Zip')
    xlabel('Force (pN)');
    set(gca,'XTick',5:5:15)
    text(12,0.45,sprintf('n = %5d',sum(Nzip))) 
    ylim([0,0.55])
  nexttile
    Nzip = histcounts(TZIPTop7FOXP1.Force,zipedges);
    pzip = Nzip/sum(Nzip)/dpzip;  % Probability density
    bar(midpoints(zipedges),pzip,1,'FaceAlpha',0.5);
    % ylabel('Zip probability density (pN)')
    xlabel('Force (pN)');
    set(gca,'XTick',5:5:15) 
    text(12,0.45,sprintf('n = %5d',sum(Nzip))) 
    ylim([0,0.55])
  nexttile
    Nzip = histcounts(TZIPTop7BSA.Force,zipedges);
    pzip = Nzip/sum(Nzip)/dpzip;  % Probability density
    bar(midpoints(zipedges),pzip,1,'FaceAlpha',0.5);
    % ylabel('Zip probability density (pN)')
    xlabel('Force (pN)');
    set(gca,'XTick',5:5:15)
    text(12,0.45,sprintf('n = %5d',sum(Nzip))) 
    ylim([0,0.55])

  ylabel(tl,'Prob. density (pN^-^1)')
  set(gcf,"Position",[180,264,1051,320]);

end
    