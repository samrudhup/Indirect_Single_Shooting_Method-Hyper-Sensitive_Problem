clc;clear all;
x_0=1;
x_f=1; 
t_0=0; 
t_f=40;
lambda_0guess=0.4;

options=optimset('Display','Iter','Tolx', 1e-8, 'TolFun', 1e-8); 
lambda_0= fsolve(@HSError_b1,lambda_0guess,options,x_0,t_0,x_f,t_f);
for ii =(10:10:t_f)
    options=optimset('Display','Iter','Tolx', 1e-8, 'TolFun', 1e-8);
    lambda_0= fsolve(@HSError_b1,lambda_0guess,options,x_0,t_0,x_f,ii);
    [E,t,P]=HSError_b1(lambda_0,x_0,t_0,x_f,ii);
    figure(ii)
    plot(t,P(:,1));
    title('Hyper Sensitivity Problem');
    xlabel('time');
    ylabel('state x');
    hold on;
end

%% HSError_b1.m

function [E,t,P] = HSError_b1(varargin)

lambda_0=varargin{1};
x_0=varargin{2};
t_0=varargin{3};
x_f=varargin{4};
t_f=varargin{5};
P_0=[x_0; lambda_0];
options=odeset('RelTol', 1e-8);
tspan=[t_0, t_f];
[t,P]=ode113(@HSode113,tspan,P_0,options);
Ptf=P(end,:);
xtf=Ptf(1,1);
E = xtf - x_f;
end

%% HSode113.m

function dPdt = HSode113(t, P)
A=[-1 -1;-1 1];
dPdt=A*P;
end

