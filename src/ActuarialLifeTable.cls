public with sharing class ActuarialLifeTable{
    //Constructor
    public ActuarialLifeTable (decimal interestRate,string sex)
    {
        IntRate = interestRate;
        Gender = sex;
        MaxAge = MaxAge;
    }
    
    //nterest Rate
    public static decimal IntRate { get;set; }
    
    //Gender (Male or Female)
    public static string Gender { get;set; }
    
    //Mortality Table
    public static List<Mortality_Table__c> Mort{
        get{
            if( Mort == null ) Mort = new List<Mortality_Table__c>();
            return Mort;
        }
        set;
    }
    //Max Age
    public static integer MaxAge{get{return database.countQuery('select Count() from Mortality_Table__c');}set;}
    
    public static Decimal disc(){
        //The discount factor :math:v = 1/(1 + i)
        return 1/(1+IntRate);
    }
    
    public static Decimal lx(Integer x) {
        //The number of persons remaining at age x.
        if (x == 0){
            return 100000;
        }else{
            return lx(x - 1) - dx(x - 1);
        }   
    }
    
    public static Decimal dx(Integer x){
        //The number of persons who die between ages x and x+1
        Decimal result = lx(x) * qx(x);
        return result;
    }
    
    public static Decimal qx(Integer x){
        if(Mort.isEmpty()){
            Mort = Database.query('SELECT Death_Probability_Male__c,Death_Probability_Female__c FROM Mortality_Table__c');          
        }
        if(Gender =='Female'){ 
            return Mort[x].Death_Probability_Female__c;
            
        }else{
            return Mort[x].Death_Probability_Male__c;
        }
    
    }    
    
    public static Decimal D_x(integer x){
        //The commutation column :math:D_{x} = l_{x}v^{x}
        return lx(x) * disc().pow(x);
    }  
    
    public static Decimal C_x(integer x){
        //The commutation column :math:`\\overline{C_x}
        return dx(x) * disc().pow(x + 1 / 2);
    } 
    
    public static Decimal N_x(integer x){
        //The commutation column :math:`N_x`.
        if (x >= MaxAge){    
            return D_x(x);
        }else{
            return N_x(x + 1) + D_x(x);
        }
    }
    
    public static Decimal M_x(integer x){
        //The commutation column :math:`M_x`.
        if (x >= MaxAge){    
            return D_x(x);
        }else{
            return M_x(x + 1) + C_x(x);
        }
    }
    
    public static Decimal Ax(integer x, integer f){
        //The present value of a lifetime assurance on a person at age ``x``
    	//payable immediately upon death, optionally with an waiting period of ``f`` years.
        if(D_x(x)==0){
            return 0;
        }else{
            return M_x(x + f) / D_x(x);
        }
    }
    
    public static Decimal Axn(integer x,integer n, integer f){
        //The present value of an assurance on a person at age ``x``
        //payable after n years, optionally with an waiting period of ``f`` years.
        if(D_x(x)==0){
            return 0;
        }else{
            return (M_x(x + f) - M_x(x + f + n)) / D_x(x);
        }
    }
    
    public static Decimal Exn(integer x, integer n){
        if(D_x(x)==0){
            return 0;
        }else{
            return D_x(x + n) / D_x(x);
        }
    }
    
    public static Decimal AnnDuenx(integer x, integer n, integer k, integer f){
        //The present value of an annuity-due.
        /*Args:
            x(int): age
            n(int): length of annuity payments in years
            k(int, optional): number of split payments in a year
            f(int, optional): waiting period in years
		*/
        //Set K to 1 by default
        if(k==null){
            k=1;
        }
        //set F to 0 by default
        if(f==null){
            f=0;
        }
        if(D_x(x)==0){
            return 0;
        }
        decimal result = (N_x(x + f) - N_x(x + f + n)) / D_x(x);
        if (k > 1){
            return result - (k - 1) / (2 * k) * (1 - D_x(x + f + n) / D_x(x));
        }else{
            return result;
        }
    }
    
    public static Decimal AnnDuex(integer x,integer k, integer f){
        /* Args:
        x(int): age
        k(int, optional): number of split payments in a year
        f(int, optional): waiting period in years
         */
        if(k==null){
            k=1;
        }
        //set F to 0 by default
        if(f==null){
            f=0;
        }
        if(D_x(x)==0){
            return 0;
        }
        decimal result = (N_x(x + f)) / D_x(x);
        if (k > 1){
            return result - (k - 1) / (2 * k);
        }else{
            return result;
        }
    }        
}
