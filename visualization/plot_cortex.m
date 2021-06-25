function plot_cortex(brain,electrodes,weights,hemi,viewside)
% function [electrodes]=ctmr_gauss_plot(cortex,electrodes,weights)

% hemi- 'l' for left hemipshere, 'r' for right hemisphere

% projects electrode locations onto their cortical spots in the 
% left hemisphere and plots about them using a gaussian kernel
% for only cortex use: 
% ctmr_gauss_plot(cortex,[0 0 0],0)
% rel_dir=which('loc_plot');
% rel_dir((length(rel_dir)-10):length(rel_dir))=[];
% addpath(rel_dir)

%     Copyright (C) 2009  K.J. Miller & D. Hermes, Dept of Neurology and Neurosurgery, University Medical Center Utrecht
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
%   Version 1.1.0, released 26-11-2009



%load in colormap
%load('loc_colormap')

M = 10;
G = fliplr(linspace(.8,1,M)) .';
cm = horzcat(G, G, G);

%CHANGED: passed in vertices from nwb plot
%brain=cortex.vert;
brain


% v='l';
% %view from which side?
% temp=1;
% while temp==1
%     disp('---------------------------------------')
%     disp('to view from right press ''r''')
%     disp('to view from left press ''l''');
%     v=input('','s');
%     if v=='l'      
%         temp=0;
%     elseif v=='r'      
%         temp=0;
%     else
%         disp('you didn''t press r, or l try again (is caps on?)')
%     end
% end

if length(weights)~=length(electrodes(:,1))
    error('you sent a different number of weights than electrodes (perhaps a whole matrix instead of vector)')
end
%gaussian "cortical" spreading parameter - in mm, so if set at 10, its 1 cm
%- distance between adjacent electrodes
gsp=50;

c=zeros(length(cortex(:,1)),1);
for i=1:length(electrodes(:,1))
    b_z=abs(brain(:,3)-electrodes(i,3));
    b_y=abs(brain(:,2)-electrodes(i,2));
    b_x=abs(brain(:,1)-electrodes(i,1));
%     d=weights(i)*exp((-(b_x.^2+b_z.^2+b_y.^2).^.5)/gsp^.5); %exponential fall off 
    d=weights(i)*exp((-(b_x.^2+b_z.^2+b_y.^2))/gsp); %gaussian 
    c=c+d';
end

% c=(c/max(c));
a=tripatch(cortex, 1, c'); %tripatch(cortex, '', c');
shading interp;
a=get(gca);
%%NOTE: MAY WANT TO MAKE AXIS THE SAME MAGNITUDE ACROSS ALL COMPONENTS TO REFLECT
%%RELEVANCE OF CHANNEL FOR COMPARISON's ACROSS CORTICES
d=a.CLim;
set(gca,'CLim',[-max(abs(d)) max(abs(d))])
l=light;
colormap(cm)
lighting gouraud; %play with lighting...
%lighting flat; %play with lighting...
% material shiny;
% material([.2 .8 .1 10 1]);
%material([0.1 1 1 1 1])
material([.2 1 .2 10 1]);

axis on
set(gcf,'Renderer', 'zbuffer')

% hemi- 'l' for left hemipshere, 'r' for right hemisphere
% views are labelled. A dash between views (Ex: medio-ventral) means that the view is in between the medial and ventral views

if strcmp(hemi,'left')
    switch viewside
        case 'medial'
            loc_view(90, 0)
        case 'lateral'
            loc_view(270, 25)
        case 'anterior'
            loc_view(180,0)
        case 'posterior'
            loc_view(0,0)
        case 'ventral' 
            loc_view(180,270)
        case 'temporal'
            loc_view(270,-80)
        case 'dorsal'
            loc_view(0,90)
        case 'latero-ventral'
            loc_view(270,-45)
        case 'medio-dorsal'
            loc_view(90,45)
        case 'medio-ventral'
            loc_view(90,-45)
        case 'medio-posterior'
            loc_view(45,0)
        case 'medio-anterior'
            loc_view(135,0)
        case 'frontal'
            loc_view(-120,10)
        case 'parietal'
            loc_view(-70,10)
    end
%     set(l,'Position',[-1 0 1])   
elseif strcmp(hemi,'right')
    switch viewside
        case 'medial'
            loc_view(270, 0)
        case 'lateral'
            loc_view(90, 25)
         case 'anterior'
            loc_view(180,0)
        case 'posterior'
            loc_view(0,0)
        case 'dorsal'
            loc_view(0,90)
        case 'ventral'
            loc_view(180,270)
        case 'temporal'
            loc_view(90,-80)
       case 'latero-ventral'
            loc_view(90,-45)
        case 'medio-dorsal'
            loc_view(270,45)
        case 'medio-ventral'
            loc_view(270,-45)
        case 'medio-posterior'
            loc_view(315,0)
        case 'medio-anterior'
            loc_view(225,0)  
        case 'frontal'
            loc_view(120,10)
        case 'parietal'
            loc_view(70,10)
    end
    
else
    error('hemisphere should be either leftl or right')
%     set(l,'Position',[1 0 1])     
end

set(gcf,'color','w')

% hcb = colorbar;
% set(hcb,'YTick',[])
            
% view(270, 0);
% set(l,'Position',[-1 0 1])        
% elseif v=='r'
% view(90, 0);
% set(l,'Position',[1 0 1])        
% end
% %exportfig
% exportfig(gcf, strcat(cd,'\figout.png'), 'format', 'png', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 4, 'Height', 3);
% disp('figure saved as "figout"');
axis off


%%
   
end
