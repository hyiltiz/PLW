function  test()
% load yeshaoqiangMirrorD26-Jan-2013;
r=1:5;
figure;

v=sort([data.righttouch;data.lefttouch]);
v1=sort([data.righttouch;]);
t1=find(data.tTrack==1);%this is left
t2=find(data.tTrack==2);

% plot(v(r),1,'ro');
hold on;
x=data.lefttouch(r);plot(x,1*ones(size(x)),'r*');
x=data.righttouch(r);plot(x,1*ones(size(x)),'b*');
x=t1(r);plot(x,2*ones(size(x)),'ro');
x=t2(r);plot(x,2*ones(size(x)),'bo');



h=gca;
set(h,'YTick',[1 2]);
set(h,'YTickLabel',{'Visual' 'Tactile'});
set(h,'XGrid','on')
axis([0 800 1 3]);

title('Tactile-Visual Stimuli (Tactile leading 150ms)');
xlabel('Flip/10ms');
ylabel('Stimuli Type');

legend('visual-right','visual-left','tactile-right','tactile-left');
legend('Location','NorthEast','Orientation','horizontal');
legend('boxoff');

% 1寸：25X38 
% 2寸：35X52 
% 3寸：89X63.5 
% 5寸：89X127 （5X3.5) 
% 6寸：102X152 (4X6) 
% 7寸：127X178 (5X7) 
% 8寸：152X203 (6X8) 
% 10寸：203X254 (8X10) 
% 12寸：203X305 (8X12) 
% 14寸：203X356 (8X14) 
% 
% 
% 12寸以下的标准尺寸 
% 12寸：250X300 
% 14寸：300X350 
% 16寸：300X400 (12x16) 
% 18寸：350X450 (14x18) 
% 20寸：400X500 (16x20) 
% 24寸：500X600 (20x24) 
% 30寸：600X800 (24x30) 
% 36寸：700X900 (24x36) (30x36) 
% 单位是以mm为单位的. 
% 
% 2寸有分大2寸与小2寸 
% 大2寸:3.5cmX5.2cm 
% 小2寸:3.5cmX4.5cm(护照上用的那种)

end
