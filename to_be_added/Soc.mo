within ;
function Soc
  input Integer as;
  input Real a[as];
  input String host;
  input Integer port;
  output Real c[as];
  output Integer result;
  external "C" result = swap(as,a,host,port,c);

  annotation(Include = "#include <sockclient.h>");
end Soc;
