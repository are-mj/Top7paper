function T = create_table(st)
% Create Matlab results table array of pull or relax structs
% Input 
%    st: pull or relax struct
  T = [];
  if isempty(st)
    return
  end

  nrips = length(st.force);
  T = [];
  for i = 1:nrips
    Filename = st.file;
    Time = st.time(i);
    Deltax = st.deltax(i);
    Force = st.force(i);
    Forceshift = st.fstep(i);
    Trapx = st.ripx(i);
    Fdot = st.fdot(i);
    Slope_b = st.pfx_b(i,1);
    Slope_a = st.pfx_a(i,i);
    Pullingspeed = st.pullingspeed(i); 
    Temperature = st.temperature(i);
    Topforce = st.topforce(i);
    Timestep = st.dt(i);
    Noise = st.noise(i);
    Cycleno = st.cycleno(i);
    Work = st.work;
    T = [T;table(Filename,Time,Deltax,Force,Temperature,Forceshift,Trapx,...
            Fdot,Slope_b,Slope_a,Pullingspeed,Topforce,Noise,Cycleno,Work,Timestep)];
  end
end
