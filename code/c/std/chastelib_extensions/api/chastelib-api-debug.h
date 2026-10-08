 /*
  divide b from a
  store the quotient in q
  and remainder in r
 */
  ax=a->length;
  while(ax>0) /*division code begin*/
  {
   ax--;
 
   /*
    left shift remainder by radix
    and place next digit from a
    as lowest digit of remainder
   */
   api_shl(r);
   r->digits[0]=a->digits[ax];

   x=0; /*used to be next quotient digit*/
   /*
    while the remainder is greater or equal to b
    subtract b from r
    keep track of how many times with i
   */
   while(1)
   {

    putstr("r==");
    put_api(r);
    putstr("\nb==");
    put_api(b);
    putstr("\n");
    cmp=api_cmp(r,b);
    printf("cmp==%d\n",cmp);
    if(cmp==-1)
    {
     printf("r is less than b: cannot subtract\n\n");
     break;
    }

    api_sub(r,b);
    put_api(r);
    putstr("\n");

    x++;
   }
   /*
    left shift quotient by radix
    and place next digit from i
    as lowest digit of quotient
   */
   api_shl(q);
   q->digits[0]=x;
 
  } /*division code end*/

 api_mov(a,q);
 api_delete(q);
 api_delete(r);
}
