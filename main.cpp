#include <iostream>
#include <vector>
#include <cstdlib>
#include <sys/time.h>
//#include "../../home/tuomas/iaca-lin64/include/iacaMarks.h"

extern "C" double vectortest(double * a,double * b,unsigned int * ind,unsigned int N);
extern "C" double vectortest_asm(double * a,double * b,unsigned int * ind,unsigned int N);
extern "C" double vectortest_asm_2(double * a,double * b,unsigned int * ind,unsigned int N);
extern "C" double vectortest_asm_3(double * a,double * b,unsigned int * ind,unsigned int N);

double get_wall_time()
{
    struct timeval time;
    if (gettimeofday(&time,NULL))
    {
        return 0.0;
    }
    return (double)time.tv_sec + (double)time.tv_usec * .000001;
}

int main()
{
    unsigned int N=10000;
    unsigned int i;
    
    unsigned int NIter=1000000;

    std::vector<double> a1(N,1);
    std::vector<double> a2(N,1);
    std::vector<double> a3(N,1);
    std::vector<double> a4(N,1);
    std::vector<double> b(N,2);
    std::vector<unsigned int> ind(N,0);
    for(unsigned int i=0;i<N;++i)
    {
	a1[i]=0;
	a2[i]=0;
	a3[i]=0;
	a4[i]=0;
	b[i]=i;
	ind[i]=std::rand()%N;
	//ind[i]=i;
    }

    double time1=-get_wall_time();
    for(i=0;i<NIter;++i)
    {
	vectortest(&a1[0],&b[0],&ind[0],N);
    }
    time1+=get_wall_time();

    double time2=-get_wall_time();
    for(i=0;i<NIter;++i)
    {
	vectortest_asm(&a2[0],&b[0],&ind[0],N);
    }
    time2+=get_wall_time();

    double time3=-get_wall_time();
    for(i=0;i<NIter;++i)
    {
	vectortest_asm_2(&a3[0],&b[0],&ind[0],N);
    }
    time3+=get_wall_time();

    double time4=-get_wall_time();
    for(i=0;i<NIter;++i)
    {
	vectortest_asm_3(&a4[0],&b[0],&ind[0],N);
    }
    time4+=get_wall_time();

    for(i=0;i<N && i<20;++i)
    {
	std::cout<<a1[i]<<" ";
    }
    std::cout<<std::endl;

    for(i=0;i<N && i<20;++i)
    {
	std::cout<<a2[i]<<" ";
    }
    std::cout<<std::endl;

    for(i=0;i<N && i<20;++i)
    {
	std::cout<<a3[i]<<" ";
    }
    std::cout<<std::endl;

    for(i=0;i<N && i<20;++i)
    {
	std::cout<<a4[i]<<" ";
    }
    std::cout<<std::endl;

    std::cout<<"Array length "<<N<<", function called "<<NIter<<" times."<<std::endl;
    std::cout<<"Gcc version: "<<time1<<std::endl;
    std::cout<<"Nonvectorized assembly implementation: "<<time2<<std::endl;
    std::cout<<"Vectorized without gather: "<<time3<<std::endl;
    std::cout<<"Vectorized with gather: "<<time4<<std::endl;

    return(0);
}
