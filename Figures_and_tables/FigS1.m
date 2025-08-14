function FigS1
[Trip,Tzip,pull,relax,t,f,x] = analyse_experiment("20230411/dA.txt");

p = pull(19);
xx = p.x(p.fitrange(1):p.fitrange(2));
ff = p.f(p.fitrange(1):p.fitrange(2));
figure; plot(xx,ff)
% xlim([192.4664  238.5536]);
% ylim([16.7193   19.5162]);
xlim([220  290]);
ylim([18   22]);
xl = xlim;
yl = ylim;
hold on;
plot(xx,polyval(p.pfx_b,xx),'k')
plot(xx,polyval(p.pfx_a,xx),'k')
p.fstep = polyval(p.pfx_b,p.ripx)-polyval(p.pfx_a,p.ripx); % correct  error in p (!!)
pos = get(gca,'position');
annotation('doublearrow',pos(1)+pos(3)*([p.ripx,p.ripx]-xl(1))/diff(xl),pos(2)+pos(4)*(p.force+[0,-p.fstep]-yl(1))/diff(yl))
annotation('doublearrow',pos(1)+pos(3)*([p.ripx,p.ripx+p.deltax]-xl(1))/diff(xl),pos(2)+pos(4)*(p.force*[1,1]-yl(1))/diff(yl))
xlabel('Trap position x')
ylabel('Pulling force f')
