clc
clear all
A=[5 1 -1 0 0 1 0 0; 6 5 0 -1 0 0 1 0; 1 4 0 0 -1 0 0 1]
b=[10;30;8];
c=[12 10 0 0 0];
C=[0 0 0 0 0 1 1 1]; %phase 1 optimization function
n_art=3;
[m,n]=size(A)
A=[A b];

disp('Phase 1');
cost=zeros(1,n+1);
cost(1:n)=C;

bv=(n-m+1):(n);
zjcj=cost(bv)*A-cost;
zcj=[zjcj;A];

smpTb=array2table(zcj);
smpTb.Properties.VariableNames={'x1','x2','s1','s2','s3','a1','a2','a3','sol'};
disp(smpTb);

while(1)
    if any(zjcj(1:n)>0)
        disp('Current BFS is not optimal')
        zc=zjcj(1:n);
        
        [entVal, pvtCol]=max(zc);

        if all(A(:,pvtCol)<0)
            disp('LPP is unbounded')
            break
        else
            sol(:)=A(:,n+1);
            column=A(:,pvtCol);
            ratio=[];
            for i=1:m
                if column(i)>0
                    ratio(i)=sol(i)./column(i);
                else
                    ratio(i)=inf;
                end
            end

            [leavVal, pvtRow]=min(ratio);
        end
        pvtKey=A(pvtRow, pvtCol);
        bv(pvtRow)=pvtCol;
        A(pvtRow,:)=A(pvtRow,:)./pvtKey;

        for i=1:m
            if i~=pvtRow
                A(i,:)=A(i,:)-A(i,pvtCol).*A(pvtRow,:);
            end
        end
        zjcj=zjcj-zjcj(pvtCol).*A(pvtRow,:);
        zcj=[zjcj;A];
        smpTb=array2table(zcj);
        smpTb.Properties.VariableNames={'x1','x2','s1','s2','s3','a1','a2','a3','sol'};
        disp(smpTb);
    else
        disp("Current BFS is optimal.")
        break;
    end
end

disp('Phase 2');
cost=zeros(1,n-n_art+1);
cost(1:n-n_art)=c
A(:,n-n_art+1:n)=[];
zjcj=cost(bv)*A-cost;
zcj=[zjcj;A];
n=n-n_art;
smpTb=array2table(zcj);
smpTb.Properties.VariableNames={'x1','x2','s1','s2','s3','sol'};
disp(smpTb);

while(1)
    if any(zjcj(1:n)<0)
        disp('Current BFS is not optimal')
        zc=zjcj(1:n);
        [entVal, pvtRow]=min(zc);
        if all(A(:,pvtCol)<0)
            disp('LPP is unbounded')
            break
        else
            sol(:)=A(:,n+1);
            column=A(:,pvtCol);
            ratio=[];
            for i=1:m
                if column(i)>0
                    ratio(i)=sol(i)./column(i);
                else
                    ratio(i)=inf
                end
            end
            [leavVal, pvtRow]=min(ratio);
        end
        pvtKey=A(pvtRow, pvtCol);
        bv(pvtRow)=pvtCol;
        A(pvtRow,:)=A(pvtRow,:)./pvtKey;

        for i=1:m
            if i~=pvtRow
                A(i,:)=A(i,:)-A(i,pvtCol).*A(pvtRow,:);
            end
        end
        zjcj=zjcj-zjcj(pvtCol).*A(pvtRow,:);
        zcj=[zjcj,A];
        smpTb=array2table(zcj);
        smpTb.Properties.VariableNames={'x1','x2','s1','s2','s3','sol'};
        disp(smpTb);
    end
end

Z = zcj(1, end);
fprintf("\nMinimised Z = \n")
disp(-1*Z)