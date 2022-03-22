clc
clear all
C=[3 2];
A=[2 4; 3 5];
B=[8;15];

y1=0:1:max(B);
x21 = (B(1) - A(1,1).*y1)./A(1,2);
x22 = (B(2) - A(2,1).*y1)./A(2,2);
x21=max(0,x21);
x22=max(0,x22);

plot(y1,x21,'r',y1,x22,'b');
title('x1 vs x2');
xlabel('Value of x1');
ylabel('Value of x2');

cx1=find(y1==0);
c1=find(x21==0);
c2=find(x22==0);


% Line1=[y1(:,[c1,cx1])]
Line1=[y1(:,[c1,cx1]); x21(:,[c1,cx1])]'
Line2=[y1(:,[c2,cx1]); x22(:,[c2,cx1])]'
crnrpts = unique([Line1 ; Line2],'rows')

solution=[0;0];
A=[A;1 0; 0 1]
B=[B;0;0];
for i=1:size(A)
    A1=A(i,:);
    B1=B(i,:);
    for j=i+1:size(A)
        A2=A(j,:);
        B2=B(j,:);
        A3=[A1;A2];
        B3=[B1;B2];
        X=A3\B3;
        solution=[solution X];
    end
end

x1=solution(1,:);
x2=solution(2,:);
solution
H1=find(2*x1+4*x2-8>0);
H2=find(3*x1+5*x2-15>0);
solution(:,[H1 H2])=[]

obj=[];

for i=1:size(solution,2)
    obj(i)=C(1)*solution(1,i)+C(2)*solution(2,i);
end

a=max(obj);
p=find(obj==a);
os1=solution(:,p);
disp(a);
disp(os1);