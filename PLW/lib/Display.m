function Display(varargin)
disp('++++++++++++++++++++++++++++++++++++');
       for i = 1:length (varargin)
         printf("Input argument %d: ", i);
         disp (varargin{i});
       end
disp('++++++++++++++++++++++++++++++++++++');
end
