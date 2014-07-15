
extern "C" void vectortest(double * a,double * b,unsigned int * ind,unsigned int N)
{
    int i;
    for(i=0;i<N;++i)
    {
	a[i]+=b[ind[i]];
    }
}
