
%__________________________________________________________________ %
%                          Multi-Objective                          %
%                Multi-objective Artificial Vultures                %
%                    Optimization Algorithm (MOAVOA)                %
%                                                                   %
%                                                                   %
%                  Developed in MATLAB R2022a (MacOs)               %
%                                                                   %
%                      Author and programmer                        %
%                ---------------------------------                  %
%                      Nima Khodadadi (ʘ‿ʘ)                        %
%                             e-Mail                                %
%                ---------------------------------                  %
%                         nkhod002@fiu.edu                          %
%                                                                   %
%                            Homepage                               %
%                ---------------------------------                  %
%                    https://nimakhodadadi.com                      %
%                                                                   %
%                                                                   %
%                                                                   %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ----------------------------------------------------------------------- %





function i=RouletteWheelSelection(p)

    r=rand;
    c=cumsum(p);
    i=find(r<=c,1,'first');

end