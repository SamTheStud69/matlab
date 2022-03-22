clear all
clc
a=[1 4 8 6; 4 1 2 1; 2 3 1 2];
B=[11;7;2];
C=[4 6 3 1];
[m,n]=size(a);
s=eye(m);
A=[a s B];

cost=zeros(1,n+m+1);
cost(1:n)=C;
bv=n+1:1:n+m;

zjcj=cost(bv)*A-cost;
zcj=[zjcj; A];
smpTb=array2table(zcj);
smpTb.Properties.VariableNames(1:n+m+1)={'x1','x2','x3','x4','s1','s2','s3','sol'};
disp(smpTb);

while(1)

    if(any(zjcj<0))
        disp('The current BFS is not optimal\n');
        zc=zjcj(1:n+m);

%       finding the entering variable and pivot column
        [entVal, pvtCol]=min(zc);
        if(all(pvtCol<0))
            disp('LPP is unbounded\n');
            break
        else
            sol(:)=A(:,n+m+1);
            column=A(:,pvtCol);
            ratio=[];
            for i=1:m
            if column(i)>0
                ratio(i)=sol(i)./column(i);
            else
                ratio(i)=inf;
            end
            end
            [leavingVal, pvtRow]=min(ratio);
            bv(pvtRow)=pvtCol;
            pvtKey=A(pvtRow,pvtCol);
            
            A(pvtRow,:)=A(pvtRow,:)./pvtKey; %dividing pvtrow by pvtkey
            for i=1:m
                if i~=pvtRow
                    A(i,:)=A(i,:)-A(i,pvtCol).*A(pvtRow,:);
                end
            end
%             zjcj(pvtCol)
%             A(pvtRow,:)
            zjcj=zjcj-zjcj(pvtCol).*A(pvtRow,:)
            zcj=[zjcj;A];
            smpTb=array2table(zcj);
            smpTb.Properties.VariableNames(1:n+m+1)={'x1','x2','x3','x4','s1','s2','s3','sol'};
            disp(smpTb);
        end
    else
        disp('The current BFS is optimal');
        break
    end
    
end