function FigS1
[~,~,pull] = analyse_experiment("20230411/dA.txt");

p = pull(19);
xx = p.x(p.fitrange(1):p.fitrange(2));
ff = p.f(p.fitrange(1):p.fitrange(2));
figure; plot(xx,ff)
xlim([220  290]);
ylim([18   22]);
hold on;
plot(xx,polyval(p.pfx_b,xx),'k')
plot(xx,polyval(p.pfx_a,xx),'k')
xlim([186.6904  250.2059]);ylim([16.3986   20.2843]);
% p.fstep = polyval(p.pfx_b,p.ripx)-polyval(p.pfx_a,p.ripx); % correct  error in p (!!)
% pos = get(gca,'position');
% annotation('doublearrow',pos(1)+pos(3)*([p.ripx,p.ripx]-xl(1))/diff(xl),pos(2)+pos(4)*(p.force+[0,-p.fstep]-yl(1))/diff(yl))
% annotation('doublearrow',pos(1)+pos(3)*([p.ripx,p.ripx+p.deltax]-xl(1))/diff(xl),pos(2)+pos(4)*(p.force*[1,1]-yl(1))/diff(yl))
h1 = annotation('doublearrow');
set(h1,'position',[ 0.4753    0.5614    0.1372    0]);
h2 = annotation('doublearrow');
set(h2,'position',[0.4753    0.5614   0  -0.1916]);
h3 = text(218.7,18.7,'Δx');
set(h3,'fontsize',12);
h4 = text(215.5,18.2,'Δf');
set(h4,'fontsize',12);
xlabel('Trap position x')
ylabel('Pulling force f')
