function e=hundungen(M,N,key0)
%%
% This code generates the keys required during the decryption process.

for i=1:200
    key0=3.925*key0*(1-key0);
end
key1=3.925;
for i=1:M
    for j=1:N
        key0=key1*key0*(1-key0);
        a(i,j)=key0;
    end
end
key3=0.2;
key2=3.925;
for i=1:M
    for j=1:N
        key3=key2*key3*(1-key3);
        b(i,j)=key3;
    end
end
key4=0.3;
key2=3.925;
for i=1:M
    for j=1:N
        key4=key2*key4*(1-key4);
        c(i,j)=key4;
    end
end
t=0.4;
w0=0.2;
w1=0.5;
w2=0.3;
w=(1-t)^2*w0+2*t*(1-t)*w1+t^2*w2;
for i=1:M
    for j=1:N
        P(i,j)=(1-t)^2*a(i,j)*w0+2*t*(1-t)*b(i,j)*w1+t^2*c(i,j)*w2;
        % d(i,j)=P(i,j)/w;
        d(i,j)=P(i,j);
    end
end
x=d;
e=round(x*255);
end