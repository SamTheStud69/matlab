clear all
clc
a=[5 1; 6 5; 1 4];
B=[10; 30; 8];
C=[12 10];
[m,n]=size(a);
s=eye(m)*(-1);
art=eye(m);
A=[a s art B];
cost=[12 10 0 0 0 -100 -100 -100 0];
bv=[6 7 8];

zjcj=cost(bv)*A-cost;
zcj=[zjcj; A];
smpTb=array2table(zcj);
smpTb.Properties.VariableNames={'x1', 'x2', 's1', 's2','s3','a1','a2','a3','sol'};
disp(smpTb);


while(1)
    if(any(zjcj<0))
        disp('Current BFS is not feasible')
        zc=zjcj(1:n+m);
        [entVal, pvtCol]=min(zc);

        if(all(A(:,pvtCol)<0))
            disp('LPP is unbounded')
            break
        else
            sol(:)=A(:,n+m+1);
            column=A(:,pvtCol);
            ratio=[];
            for i=1:m
                if column(i)<0
                    ratio(i)=inf;
                else
                    ratio(i)=sol(i)./column(i);
                end
            end
            [leaveVal, pvtRow]=min(ratio);
            bv(pvtRow)=pvtCol;
            pvtKey=A(pvtRow,pvtCol);
            A(pvtRow,:)=A(pvtRow,:)./pvtKey;

            for i=1:m
                if i~=pvtRow
                    A(i,:)=A(i,:)-A(i,pvtCol).*A(pvtRow,:);
                end
            end
            
            zjcj=zjcj-zjcj(pvtCol).*A(pvtRow,:);
            zcj=[zjcj;A];            
            smpTb=array2table(zcj);
            smpTb.Properties.VariableNames={'x1', 'x2', 's1', 's2','s3','a1','a2','a3','sol'};
            disp(smpTb);
        end
    else
        disp('Current BFS is optimal');
        break
    end
    
end

fprintf('Optimal Solution = %.4f\n',zjcj(end)*-1)
fprintf('Optimal values = %.4f\n ',A(:,end))