function sampling = getImpulse(Imax, Imin, fnm, x2)
    sampling = zeros(1,Imax-Imin);
    i=1;
    for aux=Imin:fnm:Imax
        if x2(aux)< -4.75
            sampling(i)=-5.75;
        else
            if x2(aux)< -2.75
                sampling(i)=-3.75;
            else
                if x2(aux)< -0.75
                    sampling(i)=-1.75;
                else
                    if x2(aux) < 1.25
                        sampling(i)=0.25;
                    else
                        if x2(aux)< 3.25
                            sampling(i)=2.25;
                        else
                            if x2(aux)<5.25
                                sampling(i)=4.25;
                            else
                                if x2(aux)<7.25
                                    sampling(i)=6.25;
                                else
                                    sampling(i)=8.25;
                                end
                            end
                        end
                    end
                end
            end
        end
        i=i+fnm;
    end
    
end