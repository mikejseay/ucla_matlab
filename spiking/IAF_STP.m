   function [V RELEASE]=IAF_STP(t,spiketimes,U,tfac,trec,in)
%[V R]=IAF_STP(1:500,[100 200],U,tfac,trec,(1:500)*0);
%Self-Contained function to Study the Markram/Tsodyks Model
% t=time vector in ms
% spiketimes in ms
% Utilization constand (how much is released)
% time constant of fac
% time constant of inh
% Iin = injected current (vector size t)
% EXAMPLE:
%Iin=zeros(1,2000); Iin(1000:1100)=0.06;
% [V p]=IAF_STP(1:2000,100:100:1000,0.15,270,6,Iin);
% u is essentially used for faciliation
% if u is constant e.g. tfac = 0.00001 then only synaptic depression 
% dR/dt = (1-R)/trec ? 
% u, I think is bounded between U and 1 (small values of U will help facilitation)
%%% CONSTANTS %%%
tau      = 5;         % membrane time constant
SpikeAmp = 4;
Iin      = zeros(1,length(t))+in;
%U=0.75; tfac=100; trec = 5;


%%% VARIABLES %%%
u=0; r=1; 
uP = 0; RP =1; % potential values
lastspike = -9e10;
v=0;

RELEASE(1,2)=0;
RELEASE(1,3)=0;
RELEASE(1,4)=r;

V = zeros(1,length(t));
for t=2:length(t)
   
   spike=find(t==spiketimes);
   if (~isempty(spike)) 
      SPIKE=1; 
   else
      SPIKE = 0;
   end;
   ipi=t-lastspike;
   RELEASE(t,1) = 0;

   %%% POTENTIAL STENGTH AT ALL TIMES
   RP = r*(1 - u)*exp(-ipi/trec) + 1 - exp(-ipi/trec);		 
%    uP = u*(exp(-ipi/tfac)) + U*(1-u*exp(-ipi/tfac)); 
   uP = U + (1 - U) * u * exp(-ipi/tfac);
   RELEASE(t,2) = RP*uP;
   RELEASE(t,3) = uP; % "FACILITATION"
   RELEASE(t,4) = RP; % "DEPRESSION"

   %%% ACTUAL STRENGTH AT SPIKES
   % this demonstrates that we need only calculate the change in u at the
   % time of the spike, and the simulation will still be accurate. that is,
   % the passive decay and change can be calculated independently, as they
   % simply sum here
   if SPIKE==1
%       r = r*(1 - u)*exp(-ipi/trec) + 1 - exp(-ipi/trec);	
%       u = u*(exp(-ipi/tfac)) + U*(1-u*exp(-ipi/tfac)); 
%       u = U + (1 - U) * u * exp(-ipi/tfac);
      r = r*(1 - u)*exp(-ipi/trec) + 1 - exp(-ipi/trec);	
      u = U + (1 - U) * u * exp(-ipi/tfac);

      RELEASE(t,1) = r*u;
      uP=u;
      RP=r;
   end
   
   %fprintf('t=%5d IPI=%5d  u=%5.2f   R=%5.2f lastspike=%5.2f\n',t,ipi,u,R,lastspike);
   if (~isempty(spike)) lastspike=spiketimes(spike); end
   if (V(t-1)==SpikeAmp)
      V(t)=0;
   else
%       t
      V(t)=v-v/tau+RELEASE(t,1) + Iin(t);
      if (V(t)>1), V(t)=SpikeAmp; end;
   end
   v=V(t); 
end
if (1)
   cla
   %plot(RELEASE(:,1),'linewidth',[2])
   plot(RELEASE(:,2),'c')
   plot(RELEASE(:,3),'g')
   plot(RELEASE(:,4),'r')
%    plot(V,'k','linewidth',[3])
   plot(V,'k')
end
