function DioWait
global dioIn
values=getvalue(dioIn);
while sum(values)==2
    values=getvalue(dioIn);
end
return