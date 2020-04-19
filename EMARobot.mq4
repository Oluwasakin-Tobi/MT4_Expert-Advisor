//+------------------------------------------------------------------+
//|                                                De Pip Sniper.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+


extern int MA_Period10 = 10;
extern int MA_Period20 = 20;
extern int MA_Period50 = 50;
extern int MA_Period100 = 100;
extern int MA_Period200 = 200;
extern int StopLoss = 200;
extern int TakeProfit = 300;

extern double LotSize = 0.01;

extern double     BreakEven       = 50;
extern double     BreakEvenat50       = 100;
int      digit=0;

// ---- Trailing Stops Breakeven
void TrailStops()
{        

double pPoint;
   
   if (Point == 0.00001){
      pPoint = 0.0001;
     }
   else if(Point == 0.001){
      pPoint = 0.01;
      }
      
     else{
     pPoint = Point;
     }


    int total=OrdersTotal();
    for (int cnt=0;cnt<total;cnt++)
    { 
     bool select = OrderSelect(cnt, SELECT_BY_POS); 
     //Alert("Select order for trailing loss ",select);  
     int mode=OrderType();    
        if ( OrderSymbol()==Symbol() ) 
        {
            if ( mode==OP_BUY )
            {
               if ( Bid-OrderOpenPrice()>pPoint*BreakEven ) 
               {
               double BuyStop = OrderOpenPrice();
               bool modify = OrderModify(OrderTicket(),OrderOpenPrice(),
                           NormalizeDouble(BuyStop, digit),
                           OrderTakeProfit(),0,LightGreen);
                           
               if (modify == false){
                //Alert("buy modify failed for ticket#: ", OrderTicket());
               }
               
               if (modify == true){
                //Alert("buy modify success for ticket#: ", OrderTicket());
               }
			      //return(0);
			      }
			   }
            if ( mode==OP_SELL )
            {
               if ( OrderOpenPrice()-Ask>pPoint*BreakEven ) 
               {
               double SellStop = OrderOpenPrice();
               bool modify = OrderModify(OrderTicket(),OrderOpenPrice(),
   		                  NormalizeDouble(SellStop, digit),
   		                  OrderTakeProfit(),0,Yellow);	
   		                  
   		       if (modify == false){
                //Alert("sell modify failed for ticket#: ",OrderTicket());
               } 
               if (modify == true){
                //Alert("sell modify success for ticket#: ", OrderTicket());
               }   
               //return(0);
               }    
            }
         }   
      } 
}

// ---- Trailing Stops Breakeven
void TrailStopOver100()
{        

double pPoint;
   
   if (Point == 0.00001){
      pPoint = 0.0001;
     }
   else if(Point == 0.001){
      pPoint = 0.01;
      }
      
     else{
     pPoint = Point;
     }


    int total=OrdersTotal();
    for (int cnt=0;cnt<total;cnt++)
    { 
     bool select = OrderSelect(cnt, SELECT_BY_POS); 
     //Alert("Select order for trailing loss ",select);  
     int mode=OrderType();    
        if ( OrderSymbol()==Symbol() ) 
        {
            if ( mode==OP_BUY )
            {
               if ( Bid-OrderOpenPrice()>pPoint*BreakEvenat50 ) 
               {
               double BuyStop = OrderOpenPrice()+50*pPoint;
               bool modify = OrderModify(OrderTicket(),OrderOpenPrice(),
                           NormalizeDouble(BuyStop, digit),
                           OrderTakeProfit(),0,LightGreen);
                           
               if (modify == false){
                //Alert("buy modify failed for ticket#: ", OrderTicket());
               }
               
               if (modify == true){
                Alert("buy modify success over 100 for ticket#: ", OrderTicket());
               }
			      //return(0);
			      }
			   }
            if ( mode==OP_SELL )
            {
               if ( OrderOpenPrice()-Ask>pPoint*BreakEvenat50 ) 
               {
               double SellStop = OrderOpenPrice()-50*pPoint;
               bool modify = OrderModify(OrderTicket(),OrderOpenPrice(),
   		                  NormalizeDouble(SellStop, digit),
   		                  OrderTakeProfit(),0,Yellow);	
   		                  
   		       if (modify == false){
                //Alert("sell modify failed for ticket#: ",OrderTicket());
               } 
               if (modify == true){
                Alert("sell modify success over 100 for ticket#: ", OrderTicket());
               }   
               //return(0);
               }    
            }
         }   
      } 
}


// ---- Scan Trades
int ScanTrades()
{   
   int total = OrdersTotal();
   int numords = 0;
      
   for(int cnt=0; cnt<total; cnt++) 
   {        
  bool scan = OrderSelect(cnt, SELECT_BY_POS); 
  
  if (scan == false){
         Alert("scan failed");
         }
              
   if(OrderSymbol() == Symbol() && OrderType()<=OP_SELL) 
   numords++;
   }
   return(numords);
   
    
}
int OnInit()
  {
   Alert("Expert Advisor has been launched");
   
   //int digit = MarketInfo(Symbol(),MODE_DIGITS);
   
   //Alert("Digit", digit);
   
    string cookie=NULL,headers;
   char post[],result[];
   int res;
//--- to enable access to the server, you should add URL "https://www.google.com/finance"
//--- in the list of allowed URLs (Main Menu->Tools->Options, tab "Expert Advisors"):
   string message1 = "Welcome to de pip sniper on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+ message1;
  
//--- Reset the last error code
   ResetLastError();
//--- Loading a html page from Google Finance
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
   
   Print(MarketInfo(Symbol(), MODE_LOTSIZE));
Print(MarketInfo(Symbol(), MODE_MINLOT));
Print(MarketInfo(Symbol(), MODE_LOTSTEP));
Print(MarketInfo(Symbol(), MODE_MAXLOT));
   
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Alert("Expert Advisor has been terminated");
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
 /* double  iMA( 
   string       symbol,           // symbol 
   int          timeframe,        // timeframe 
   int          ma_period,        // MA averaging period 
   int          ma_shift,         // MA shift 
   int          ma_method,        // averaging method //0 OR MODE_SMA=sma, 1 0R MODE_EMA=ema, 2=smma, 3=lwma, 4=lsma
   int          applied_price,    // applied price  //0=close, 1=open, 2=high, 3=low, 4=median(high+low)/2, 5=typical(high+low+close)/3, 6=weighted(high+low+close+close)/4
   int          shift             // shift //0=Current, 1=Previous
   ); */
   
   digit  = MarketInfo(Symbol(),MODE_DIGITS);

   
   if (ScanTrades()<1);
   else
   if (BreakEven>0) TrailStops();
   else
   if (BreakEvenat50>0) TrailStopOver100();
   
   double vPoint;
   
   if (Point == 0.00001){
      vPoint = 0.0001;
     }
   else if(Point == 0.001){
      vPoint = 0.01;
      }
      
     else{
     vPoint = Point;
     }
  
  double ma10 = NormalizeDouble(iMA(Symbol(),Period(),MA_Period10,0,1,0,0), Digits); 
  double ma10Prev = NormalizeDouble(iMA(Symbol(),Period(),MA_Period10,0,1,0,1), Digits);
  double ma20 = NormalizeDouble(iMA(Symbol(),Period(),MA_Period20,0,1,0,0), Digits);
  double ma20Prev = NormalizeDouble(iMA(Symbol(),Period(),MA_Period20,0,1,0,1), Digits);
  double ma50 = NormalizeDouble(iMA(Symbol(),Period(),MA_Period50,0,1,0,0), Digits);
  double ma50Prev = NormalizeDouble(iMA(Symbol(),Period(),MA_Period50,0,1,0,1), Digits);
  double ma100 = NormalizeDouble(iMA(Symbol(),Period(),MA_Period100,0,1,0,0), Digits);
  double ma100Prev = NormalizeDouble(iMA(Symbol(),Period(),MA_Period100,0,1,0,1), Digits);
  double ma200 = NormalizeDouble(iMA(Symbol(),Period(),MA_Period200,0,1,0,0), Digits);
  double ma200Prev = NormalizeDouble(iMA(Symbol(),Period(),MA_Period200,0,1,0,1), Digits);
  double StopLossValue;
  double TakeProfitValue;
  double Stop200LossValue;
  double Take200ProfitValue;
  double Stop50and200LossValue;
  double Take50and200ProfitValue;
  
  double Stop10and100LossValue;
  double Take10and100ProfitValue;
  double Stop20and100LossValue;
  double Take20and100ProfitValue;
  double Stop50and100LossValue;
  double Take50and100ProfitValue;
  double Stop100and200LossValue;
  double Take100and200ProfitValue;
  
  double Stop10and20LossValue;
  double Take10and20ProfitValue;
  double Stop10and50LossValue;
  double Take10and50ProfitValue;
  double Stop10and200LossValue;
  double Take10and200ProfitValue;
   
  
  static int countBuy20 = 1;
  static int countSell20 = 1;
  static int countBuy50 = 1;
  static int countSell50 = 1;
  static int countBuy200 = 1;
  static int countSell200 = 1;
  static int countBuy10and20 = 1;
  static int countSell10and20 = 1;
  static int countBuy10and50 = 1;
  static int countSell10and50 = 1;
  static int countBuy10and200 = 1;
  static int countSell10and200 = 1;
  
   static int countBuy10and100 = 1;
  static int countSell10and100 = 1;
  static int countBuy20and100 = 1;
  static int countSell20and100 = 1;
  static int countBuy50and100 = 1;
  static int countSell50and100 = 1;
  static int countBuy100and200 = 1;
  static int countSell100and200 = 1;
  
  static int countBuy50and200 = 1;
  static int countSell50and200 = 1;
  static int countBuyTriple = 1;
  static int countSellTriple = 1;
  static int countBuyQuadrant = 1;
  static int countSellQuadrant = 1;
  
  
  
  //static int modifyCount50 = 1;
  //static int modifyCount100 = 1;
  
  static double TakeProfitCheck = 0;
  static double TakeProfitCheckSell = 0;
  static double Take200ProfitCheck = 0;
  static double Take200ProfitCheckSell = 0;
  static double Take50and200ProfitCheck = 0;
  static double Take50and200ProfitCheckSell = 0;
  
   static double Take10and100ProfitCheck = 0;
  static double Take10and100ProfitCheckSell = 0;
  static double Take20and100ProfitCheck = 0;
  static double Take20and100ProfitCheckSell = 0;
  static double Take50and100ProfitCheck = 0;
  static double Take50and100ProfitCheckSell = 0;
  static double Take100and200ProfitCheck = 0;
  static double Take100and200ProfitCheckSell = 0;
  
  static double Take10and20ProfitCheck = 0;
  static double Take10and20ProfitCheckSell = 0;
  static double Take10and50ProfitCheck = 0;
  static double Take10and50ProfitCheckSell = 0;
  static double Take10and200ProfitCheck = 0;
  static double Take10and200ProfitCheckSell = 0;
  
  static double StopLossModifySell = 0;
  static double StopLossModifyBuy = 0;
  static double Stop200LossModifySell = 0;
  static double Stop200LossModifyBuy = 0;
  static double Stop50and200LossModifySell = 0;
  static double Stop50and200LossModifyBuy = 0;
  
  static double Stop10and100LossModifySell = 0;
  static double Stop10and100LossModifyBuy = 0;
  static double Stop20and100LossModifySell = 0;
  static double Stop20and100LossModifyBuy = 0;
  static double Stop50and100LossModifySell = 0;
  static double Stop50and100LossModifyBuy = 0;
  static double Stop100and200LossModifySell = 0;
  static double Stop100and200LossModifyBuy = 0;
  
  static double Stop10and20LossModifySell = 0;
  static double Stop10and20LossModifyBuy = 0;
  static double Stop10and50LossModifySell = 0;
  static double Stop10and50LossModifyBuy = 0;
  static double Stop10and200LossModifySell = 0;
  static double Stop10and200LossModifyBuy = 0;
  
  
  static int openBuy1 = 0;
  static int openSell1 = 0;
  static int openBuy2 = 0;
  static int openSell2 = 0;
  static int openBuy3 = 0;
  static int openSell3 = 0;
  
  static int openBuy10and100 = 0;
  static int openSell10and100 = 0;
  static int openBuy20and100 = 0;
  static int openSell20and100 = 0;
  static int openBuy50and100 = 0;
  static int openSell50and100 = 0;
  static int openBuy100and200 = 0;
  static int openSell100and200 = 0;
  
  static int openBuy10and20 = 0;
  static int openSell10and20 = 0;
  static int openBuy10and50 = 0;
  static int openSell10and50 = 0;
  static int openBuy10and200 = 0;
  static int openSell10and200 = 0;
  
  static double StopLossOn50 = 0;
  static double StopLossOnSell50 = 0;
  static double Stop200LossOn50 = 0;
  static double Stop200LossOnSell50 = 0;
  static double Stop50and200LossOn50 = 0;
  static double Stop50and200LossOnSell50 = 0;
  
  static double Stop10and100LossOn50 = 0;
  static double Stop10and100LossOnSell50 = 0;
  static double Stop20and100LossOn50 = 0;
  static double Stop20and100LossOnSell50 = 0;
  static double Stop50and100LossOn50 = 0;
  static double Stop50and100LossOnSell50 = 0;
  static double Stop100and200LossOn50 = 0;
  static double Stop100and200LossOnSell50 = 0;
  
  static double Stop10and20LossOn50 = 0;
  static double Stop10and20LossOnSell50 = 0;
  static double Stop10and50LossOn50 = 0;
  static double Stop10and50LossOnSell50 = 0;
  static double Stop10and200LossOn50 = 0;
  static double Stop10and200LossOnSell50 = 0;
  
  static int ticket = 0;
  static int ticket2 = 0;
  static int ticket3 = 0;
  
  static int ticket10and100 = 0;
  static int ticket20and100 = 0;
  static int ticket50and100 = 0;
  static int ticket100and200 = 0;
  
  static int ticket10and20 = 0;
  static int ticket10and50 = 0;
  static int ticket10and200 = 0;
  
  
  
  //---------------------------20EMA STARTED----------------------------------------------------------------------------
  
  // FOR 10EMA CROSSING 20EMA................................................................
  if(ma10>ma20 && ma10Prev<ma20Prev){
  
   
    //TO OPEN A BUY ORDER-------------------------------------------------------
      if(countBuy10and20==1&&openBuy10and20==0){
      
      //TO SEND THE MESSAGE
      string message = "10EMA has crossed 20EMA from below. A BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
      
      Stop10and20LossValue = Bid - StopLoss*vPoint;
      Stop10and20LossModifyBuy = Bid; //for check
      Take10and20ProfitValue = Bid + TakeProfit*vPoint;
      Take10and20ProfitCheck = Bid + TakeProfit*vPoint; //for check
      
     /* bool ress = OrderSelect(ticket10and20,SELECT_BY_TICKET);
      if(ress==true){
      OrderType();
         bool sell = OrderClose(ticket10and20, LotSize, Ask, 10);
         Alert("First 10 and 20ema close sell ticket #", ticket10and20);
            if(sell==false){
            Alert("Error 10 and 20ema closing sell");
            }
         
      }*/
      Alert ("Strong Buy and stop loss: ", Stop10and20LossValue, " while take profit is: ", Take10and20ProfitValue, " on entry value: ", Bid);
      
      ticket10and20 = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 10, Stop10and20LossValue, Take10and20ProfitValue, "10and20 Buy Strong Order");
         Alert("successful 10 and 20ema  buy ticket", ticket10and20);
            if (ticket10and20 < 0){
               Alert("Error 10 and 20ema sending ticket");
            }
            
      openBuy10and20 = 1;
      countBuy10and20++;
      countSell10and20 = 1;
      openSell10and20 = 0;
      }
      else{
      //Alert ("Strong buy not first");
      }
  }
  //10EMA AND 20EMA BUY FINISH-----------------------------------------------------
  
  
  
  
  
  //WHEN 10EMA CROSSES 20EMA FROM ABOVE------------------------------------------------
  if(ma10<ma20 && ma10Prev>ma20Prev){
  
  
    //TO OPEN A SELL ORDER-----------------------
      if(countSell10and20==1&&openSell10and20==0){
      
      
      //TO SEND THE MESSAGE
      string message = "10EMA has crossed 20EMA from above. A SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
      
      Stop10and20LossValue = Ask + StopLoss*vPoint;
      Stop10and20LossModifySell = Ask; //FOR CHECK
      Take10and20ProfitValue = Ask - TakeProfit*vPoint;
      Take10and20ProfitCheckSell = Ask - TakeProfit*vPoint; //FOR CHECK
      
      
       /* bool ressbuy = OrderSelect(ticket10and20,SELECT_BY_TICKET);
      if(ressbuy==true){
      OrderType();
         bool buy = OrderClose(ticket10and20, LotSize, Bid, 10);
         Alert("First close 10 and 20ema buy ticket #", ticket10and20);
            if(buy==false){
            Alert("Error 10 and 20ema closing buy");
            }
         
      }*/
      
      Alert ("Strong Sell and stop loss: ", Stop10and20LossValue, " while take profit is: ", Take10and20ProfitValue, " on entry value: ", Ask);
      
          ticket10and20 = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 10, Stop10and20LossValue, Take10and20ProfitValue, "10and20 Sell Strong Order");
            Alert("successful 10 and 20ema sell ticket #", ticket10and20);
            if (ticket10and20 < 0){
               Alert("Error 10 and 20 ema sell sending ticket");
            }
      openSell10and20 = 1;
      countSell10and20++;
      countBuy10and20 = 1;
      openBuy10and20 =0;
      }
      else{
      //Alert ("Strong Sell not first");
      }
  } 
  
  //-------------------------------------------20EMA FINISHES----------------------------------------------------------
  
  
  //------------------------------------------50EMA STARTED----------------------------------------------------------------------------
  
  // FOR 10EMA CROSSING 50EMA................................................................
  if(ma10>ma50 && ma10Prev<ma50Prev){
  
  
    //TO OPEN A BUY ORDER-------------------------------------------------------
      if(countBuy10and50==1&&openBuy10and50==0){
      
      
      //TO SEND THE MESSAGE
       string message = "10EMA has crossed 50EMA from below. A BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
      
      Stop10and50LossValue = Bid - StopLoss*vPoint;
      Stop10and50LossModifyBuy = Bid; //for check
      Take10and50ProfitValue = Bid + TakeProfit*vPoint;
      Take10and50ProfitCheck = Bid + TakeProfit*vPoint; //for check
      
     /* bool ress = OrderSelect(ticket10and50,SELECT_BY_TICKET);
      if(ress==true){
      OrderType();
         bool sell = OrderClose(ticket10and50, LotSize, Ask, 10);
         Alert("First 10 and 50ema close sell ticket #", ticket10and50);
            if(sell==false){
            Alert("Error 10 and 50ema closing sell");
            }
         
      }*/
      Alert ("Strong Buy and stop loss: ", Stop10and50LossValue, " while take profit is: ", Take10and50ProfitValue, " on entry value: ", Bid);
      
      ticket10and50 = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 10, Stop10and50LossValue, Take10and50ProfitValue, "10and50 Buy Strong Order");
         Alert("successful 10 and 50ema  buy ticket", ticket10and50);
            if (ticket10and50 < 0){
               Alert("Error 10 and 50ema sending ticket");
            }
            
      openBuy10and50 = 1;
      countBuy10and50++;
      countSell10and50 = 1;
      openSell10and50 = 0;
      }
      else{
      //Alert ("Strong buy not first");
      }
  }
  //10EMA AND 50EMA BUY FINISH-----------------------------------------------------
  
  
  
  
  
  //WHEN 10EMA CROSSES 50EMA FROM ABOVE------------------------------------------------
  if(ma10<ma50 && ma10Prev>ma50Prev){
  
  
    //TO OPEN A SELL ORDER-----------------------
      if(countSell10and50==1&&openSell10and50==0){
      
      
      //TO SEND THE MESSAGE
       string message = "10EMA has crossed 50EMA from above. A SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
      
      Stop10and50LossValue = Ask + StopLoss*vPoint;
      Stop10and50LossModifySell = Ask; //FOR CHECK
      Take10and50ProfitValue = Ask - TakeProfit*vPoint;
      Take10and50ProfitCheckSell = Ask - TakeProfit*vPoint; //FOR CHECK
      
      
       /* bool ressbuy = OrderSelect(ticket10and50,SELECT_BY_TICKET);
      if(ressbuy==true){
      OrderType();
         bool buy = OrderClose(ticket10and50, LotSize, Bid, 10);
         Alert("First close 10 and 50ema buy ticket #", ticket10and50);
            if(buy==false){
            Alert("Error 10 and 50ema closing buy");
            }
         
      }*/
      
      Alert ("Strong Sell and stop loss: ", Stop10and50LossValue, " while take profit is: ", Take10and50ProfitValue, " on entry value: ", Ask);
      
          ticket10and50 = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 10, Stop10and50LossValue, Take10and50ProfitValue, "10and50 Sell Strong Order");
            Alert("successful 10 and 50ema sell ticket #", ticket10and50);
            if (ticket10and50 < 0){
               Alert("Error 10 and 50 ema sell sending ticket");
            }
      openSell10and50 = 1;
      countSell10and50++;
      countBuy10and50 = 1;
      openBuy10and50 =0;
      }
      else{
      //Alert ("Strong Sell not first");
      }
  }
  
  
  // FOR 20EMA CROSSING 50EMA................................................................
  if(ma20>ma50 && ma20Prev<ma50Prev){
  
  
    //TO OPEN A BUY ORDER-------------------------------------------------------
      if(countBuy50==1&&openBuy1==0){
      
      //TO SEND THE MESSAGE
       string message = "20EMA has crossed 50EMA from below. A BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
      
      StopLossValue = Bid - StopLoss*vPoint;
      StopLossModifyBuy = Bid; //for check
      TakeProfitValue = Bid + TakeProfit*vPoint;
      TakeProfitCheck = Bid + TakeProfit*vPoint; //for check
      
     /* bool ress = OrderSelect(ticket,SELECT_BY_TICKET);
      if(ress==true){
      OrderType();
         bool sell = OrderClose(ticket, LotSize, Ask, 10);
         Alert("First 20 and 50ema close sell ticket #", ticket);
            if(sell==false){
            Alert("Error 20 and 50ema closing sell");
            }
         
      }*/
      Alert ("Strong Buy and stop loss: ", StopLossValue, " while take profit is: ", TakeProfitValue, " on entry value: ", Bid);
      
      ticket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 10, StopLossValue, TakeProfitValue, "Buy Strong Order");
         Alert("successful 20 and 50ema  buy ticket", ticket);
            if (ticket < 0){
               Alert("Error 20 and 50ema sending ticket");
            }
            
      openBuy1 = 1;
      countBuy50++;
      countSell50 = 1;
      openSell1 = 0;
      }
      else{
      //Alert ("Strong buy not first");
      }
  }
  //20EMA AND 50EMA BUY FINISH-----------------------------------------------------
  
  
  
  
  
  //WHEN 20EMA CROSSES 50EMA FROM ABOVE------------------------------------------------
  if(ma20<ma50 && ma20Prev>ma50Prev){
  
  
    //TO OPEN A SELL ORDER-----------------------
      if(countSell50==1&&openSell1==0){
      
      //TO SEND THE MESSAGE
       string message = "20EMA has crossed 50EMA from above. A SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
      
      StopLossValue = Ask + StopLoss*vPoint;
      StopLossModifySell = Ask; //FOR CHECK
      TakeProfitValue = Ask - TakeProfit*vPoint;
      TakeProfitCheckSell = Ask - TakeProfit*vPoint; //FOR CHECK
      
      
       /* bool ressbuy = OrderSelect(ticket,SELECT_BY_TICKET);
      if(ressbuy==true){
      OrderType();
         bool buy = OrderClose(ticket, LotSize, Bid, 10);
         Alert("First close 20 and 50ema buy ticket #", ticket);
            if(buy==false){
            Alert("Error 20 and 50ema closing buy");
            }
         
      }*/
      
      Alert ("Strong Sell and stop loss: ", StopLossValue, " while take profit is: ", TakeProfitValue, " on entry value: ", Ask);
      
          ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 10, StopLossValue, TakeProfitValue, "Sell Strong Order");
            Alert("successful 20 and 50ema sell ticket #", ticket);
            if (ticket < 0){
               Alert("Error 20 and 50 ema sell sending ticket");
            }
      openSell1 = 1;
      countSell50++;
      countBuy50 = 1;
      openBuy1 =0;
      }
      else{
      //Alert ("Strong Sell not first");
      }
  }
  
  //---------------------------50EMA FINISHED-----------------------------------------------------------------------
  
  
  
  
  
  
  
  //FOR THE TRIPLE STRONG INDICATOR
  
  if((ma10>ma50 && ma10Prev<ma50Prev)&&(ma20>ma50 && ma10Prev<ma20Prev)){
      if(countBuyTriple==1){
      
       //TO SEND THE MESSAGE
       string message = "10EMA AND 20EMA has crossed 50EMA at a point from below. A TRIPLE STRONG BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
     
     
      
      StopLossValue = Bid - StopLoss*vPoint;
      TakeProfitValue = Bid + TakeProfit*vPoint;
      Alert ("Triple Strong Buy and stop loss: ", StopLossValue, " while take profit is: ", TakeProfitValue, " on entry value: ", Bid);
      
            
      countBuyTriple++;
      countSellTriple = 1;
      }
      else{
      }
  }
  
  //TRIPLE SELL--------------------------------------------------------
  if((ma10<ma50 && ma10Prev>ma50Prev)&&(ma20<ma50 && ma20Prev>ma50Prev)){
      if(countSellTriple==1){
      
      
      //TO SEND THE MESSAGE
       string message = "10EMA AND 20EMA has crossed 50EMA at a point from ABOVE. A TRIPLE STRONG SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
      
      StopLossValue = Ask + StopLoss*vPoint;
      TakeProfitValue = Ask - TakeProfit*vPoint;
      Alert ("Triple Strong Sell and stop loss: ", StopLossValue, " while take profit is: ", TakeProfitValue, " on entry value: ", Ask);
      
            
      countSellTriple++;
      countBuyTriple = 1;
      }
      else{
      }
  }
  
  //FOR THE QUADRANT
  
  if((ma10>ma200 && ma10Prev<ma200Prev)&&(ma20>ma200 && ma20Prev<ma200Prev)&&(ma50>ma200 && ma50Prev<ma200Prev)){
      if(countBuyQuadrant==1){
      
      //TO SEND THE MESSAGE
       string message = "10EMA AND 20EMA and 50EMA has crossed 200EMA at a point from below. A QUADRANT BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
     
      
      StopLossValue = Bid - StopLoss*vPoint;
      TakeProfitValue = Bid + TakeProfit*vPoint;
      Alert ("Quadrant Strong Buy and stop loss: ", StopLossValue, " while take profit is: ", TakeProfitValue, " on entry value: ", Bid);
      
            
      countBuyQuadrant++;
      countSellQuadrant = 1;
      }
      else{
      }
  }
  
  //QUADRANT SELL-------------------------------------------
  if((ma10<ma200 && ma10Prev>ma200Prev)&&(ma20<ma200 && ma20Prev>ma200Prev)&&(ma50<ma200 && ma50Prev>ma200Prev)){
      if(countSellQuadrant==1){
      
      
      //TO SEND THE MESSAGE
       string message = "10EMA AND 20EMA and 50EMA has crossed 200EMA at a point from above. A QUADRANT SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
      
      StopLossValue = Ask + StopLoss*vPoint;
      TakeProfitValue = Ask - TakeProfit*vPoint;
      Alert ("Quadrant Strong Sell and stop loss: ", StopLossValue, " while take profit is: ", TakeProfitValue, " on entry value: ", Ask);
      
            
      countSellQuadrant++;
      countBuyQuadrant = 1;
      }
      else{
      }
  }
  
  
  
  //-------------------------------------------------------FOR 100 EMAS----------------------------------------------------
  
  // FOR 10EMA CROSSING 100EMA................................................................
  if(ma10>ma100 && ma10Prev<ma100Prev){
  
    
    //TO OPEN A BUY ORDER-------------------------------------------------------
      if(countBuy10and100==1&&openBuy10and100==0){
      
      
      //TO SEND THE MESSAGE
       string message = "10EMA has crossed 100EMA from below. A BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop10and100LossValue = Bid - StopLoss*vPoint;
      Stop10and100LossModifyBuy = Bid; //for check
      Take10and100ProfitValue = Bid + TakeProfit*vPoint;
      Take10and100ProfitCheck = Bid + TakeProfit*vPoint; //for check
      
     /* bool ress = OrderSelect(ticket10and100,SELECT_BY_TICKET);
      if(ress==true){
      OrderType();
         bool sell = OrderClose(ticket10and100, LotSize, Ask, 10);
         Alert("First 10ema and 100ema close sell ticket #", ticket10and100);
            if(sell==false){
            Alert("Error closing 10ema and 100ema sell");
            }
         
      }*/
      Alert (" 10and100 Very Strong Buy and stop loss: ", Stop10and100LossValue, " while take profit is: ", Take10and100ProfitValue, " on entry value: ", Bid);
      
      ticket10and100 = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 10, Stop10and100LossValue, Take10and100ProfitValue, "Buy 10and100 VeryStrong Order");
         Alert("successful 10ema and 100ema buy ticket", ticket10and100);
            if (ticket10and100 < 0){
               Alert("Error 10ema and 100ema sending ticket");
            }
      openBuy10and100 = 1;
      countBuy10and100++;
      countSell10and100 = 1;
      openSell10and100 = 0;
      }
      else{
      //Alert ("Strong buy not first");
      }
  }
  //10EMA AND 1OOEMA BUY FINISH-----------------------------------------------------
  
  
  
  
  
  //WHEN 10EMA CROSSES 100EMA FROM ABOVE------------------------------------------------
  if(ma10<ma100 && ma10Prev>ma100Prev){
  
  
    //TO OPEN A SELL ORDER-----------------------
      if(countSell10and100==1&&openSell10and100==0){
      
      
      //TO SEND THE MESSAGE
       string message = "10EMA has crossed 100EMA from above. A SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop10and100LossValue = Ask + StopLoss*vPoint;
      Stop10and100LossModifySell = Ask; //FOR CHECK
      Take10and100ProfitValue = Ask - TakeProfit*vPoint;
      Take10and100ProfitCheckSell = Ask - TakeProfit*vPoint; //FOR CHECK
      
      
       /* bool ressbuy = OrderSelect(ticket10and100,SELECT_BY_TICKET);
      if(ressbuy==true){
      OrderType();
         bool buy = OrderClose(ticket10and100, LotSize, Bid, 10);
         Alert("First 10 and 100ema close buy ticket #", ticket10and100);
            if(buy==false){
            Alert("Error closing 10ema and 100ema buy");
            }
         
      }*/
      
      Alert ("10ema and 100ema Very Strong Sell and stop loss: ", Stop10and100LossValue, " while take profit is: ", Take10and100ProfitValue, " on entry value: ", Ask);
      
          ticket10and100 = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 10, Stop10and100LossValue, Take10and100ProfitValue, "10ema and 100ema Very Sell Strong Order");
            Alert("successful 10ema and 100 ema sell ticket", ticket10and100);
            if (ticket10and100 < 0){
               Alert("Error sending 10ema and 100ema ticket");
            }
      openSell10and100 = 1;
      countSell10and100++;
      countBuy10and100 = 1;
      openBuy10and100 =0;
      }
      else{
      //Alert ("Strong Sell not first");
      }
  }
  //10EMA AND 100EMA SELL FINISH-------------------------------------------------------------
  
  
  
  
   // FOR 20EMA CROSSING 100EMA................................................................
  if(ma20>ma100 && ma20Prev<ma100Prev){
  
    
    //TO OPEN A BUY ORDER-------------------------------------------------------
      if(countBuy20and100==1&&openBuy20and100==0){
      
      
      //TO SEND THE MESSAGE
       string message = "20EMA has crossed 100EMA from below. A BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop20and100LossValue = Bid - StopLoss*vPoint;
      Stop20and100LossModifyBuy = Bid; //for check
      Take20and100ProfitValue = Bid + TakeProfit*vPoint;
      Take20and100ProfitCheck = Bid + TakeProfit*vPoint; //for check
      
      /*bool ress = OrderSelect(ticket20and100,SELECT_BY_TICKET);
      if(ress==true){
      OrderType();
         bool sell = OrderClose(ticket20and100, LotSize, Ask, 10);
         Alert("First 20ema and 100ema close sell ticket #", ticket20and100);
            if(sell==false){
            Alert("Error closing 20ema and 100ema sell");
            }
         
      }*/
      Alert (" 20and100 Very Strong Buy and stop loss: ", Stop20and100LossValue, " while take profit is: ", Take20and100ProfitValue, " on entry value: ", Bid);
      
      ticket20and100 = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 10, Stop20and100LossValue, Take20and100ProfitValue, "Buy 20and100 VeryStrong Order");
         Alert("successful 20ema and 100ema buy ticket", ticket20and100);
            if (ticket20and100 < 0){
               Alert("Error 20ema and 100ema sending ticket");
            }
      openBuy20and100 = 1;
      countBuy20and100++;
      countSell20and100 = 1;
      openSell20and100 = 0;
      }
      else{
      //Alert ("Strong buy not first");
      }
  }
  //20EMA AND 1OOEMA BUY FINISH-----------------------------------------------------
  
  
  
  
  
  //WHEN 20EMA CROSSES 100EMA FROM ABOVE------------------------------------------------
  if(ma20<ma100 && ma20Prev>ma100Prev){
  
  
    //TO OPEN A SELL ORDER-----------------------
      if(countSell20and100==1&&openSell20and100==0){
      
      
       //TO SEND THE MESSAGE
        string message = "20EMA has crossed 100EMA from above. A SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop20and100LossValue = Ask + StopLoss*vPoint;
      Stop20and100LossModifySell = Ask; //FOR CHECK
      Take20and100ProfitValue = Ask - TakeProfit*vPoint;
      Take20and100ProfitCheckSell = Ask - TakeProfit*vPoint; //FOR CHECK
      
      
      /*  bool ressbuy = OrderSelect(ticket20and100,SELECT_BY_TICKET);
      if(ressbuy==true){
      OrderType();
         bool buy = OrderClose(ticket20and100, LotSize, Bid, 10);
         Alert("First 20 and 100ema close buy ticket #", ticket20and100);
            if(buy==false){
            Alert("Error closing 20ema and 100ema buy");
            }
         
      }*/
      
      Alert ("20ema and 100ema Very Strong Sell and stop loss: ", Stop20and100LossValue, " while take profit is: ", Take20and100ProfitValue, " on entry value: ", Ask);
      
          ticket20and100 = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 10, Stop20and100LossValue, Take20and100ProfitValue, "10ema and 100ema Very Sell Strong Order");
            Alert("successful 20ema and 100 ema sell ticket", ticket20and100);
            if (ticket20and100 < 0){
               Alert("Error sending 20ema and 100ema ticket");
            }
      openSell20and100 = 1;
      countSell20and100++;
      countBuy20and100 = 1;
      openBuy20and100 =0;
      }
      else{
      //Alert ("Strong Sell not first");
      }
  }
  //20EMA AND 100EMA SELL FINISH
  
  
  
  
  
   // FOR 50EMA CROSSING 100EMA................................................................
  if(ma50>ma100 && ma50Prev<ma100Prev){
  
    
    //TO OPEN A BUY ORDER-------------------------------------------------------
      if(countBuy50and100==1&&openBuy50and100==0){
      
      
      
      
      //TO SEND THE MESSAGE
        string message = "50EMA has crossed 100EMA from below. A BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop50and100LossValue = Bid - StopLoss*vPoint;
      Stop50and100LossModifyBuy = Bid; //for check
      Take50and100ProfitValue = Bid + TakeProfit*vPoint;
      Take50and100ProfitCheck = Bid + TakeProfit*vPoint; //for check
      
      /*bool ress = OrderSelect(ticket50and100,SELECT_BY_TICKET);
      if(ress==true){
      OrderType();
         bool sell = OrderClose(ticket50and100, LotSize, Ask, 10);
         Alert("First 50ema and 100ema close sell ticket #", ticket50and100);
            if(sell==false){
            Alert("Error closing 50ema and 100ema sell");
            }
         
      }*/
      Alert (" 50and100 Very Strong Buy and stop loss: ", Stop50and100LossValue, " while take profit is: ", Take50and100ProfitValue, " on entry value: ", Bid);
      
      ticket50and100 = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 10, Stop50and100LossValue, Take50and100ProfitValue, "Buy 10and100 VeryStrong Order");
         Alert("successful 50ema and 100ema buy ticket", ticket50and100);
            if (ticket50and100 < 0){
               Alert("Error 50ema and 100ema sending ticket");
            }
      openBuy50and100 = 1;
      countBuy50and100++;
      countSell50and100 = 1;
      openSell50and100 = 0;
      }
      else{
      //Alert ("Strong buy not first");
      }
  }
  //50EMA AND 1OOEMA BUY FINISH-----------------------------------------------------
  
  
  
  
  
  //WHEN 50EMA CROSSES 100EMA FROM ABOVE------------------------------------------------
  if(ma50<ma100 && ma50Prev>ma100Prev){
  
  
    //TO OPEN A SELL ORDER-----------------------
      if(countSell50and100==1&&openSell50and100==0){
      
      
      //TO SEND THE MESSAGE
        string message = "50EMA has crossed 100EMA from above. A SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop50and100LossValue = Ask + StopLoss*vPoint;
      Stop50and100LossModifySell = Ask; //FOR CHECK
      Take50and100ProfitValue = Ask - TakeProfit*vPoint;
      Take50and100ProfitCheckSell = Ask - TakeProfit*vPoint; //FOR CHECK
      
      
      /*  bool ressbuy = OrderSelect(ticket50and100,SELECT_BY_TICKET);
      if(ressbuy==true){
      OrderType();
         bool buy = OrderClose(ticket50and100, LotSize, Bid, 10);
         Alert("First 50 and 100ema close buy ticket #", ticket50and100);
            if(buy==false){
            Alert("Error closing 50ema and 100ema buy");
            }
         
      }*/
      
      Alert ("50ema and 100ema Very Strong Sell and stop loss: ", Stop50and100LossValue, " while take profit is: ", Take50and100ProfitValue, " on entry value: ", Ask);
      
          ticket50and100 = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 10, Stop50and100LossValue, Take50and100ProfitValue, "50ema and 100ema Very Sell Strong Order");
            Alert("successful 50ema and 100 ema sell ticket", ticket50and100);
            if (ticket50and100 < 0){
               Alert("Error sending 50ema and 100ema ticket");
            }
      openSell50and100 = 1;
      countSell50and100++;
      countBuy50and100 = 1;
      openBuy50and100 =0;
      }
      else{
      //Alert ("Strong Sell not first");
      }
  }
  //50EMA AND 100EMA SELL FINISH-----------------------------------------------------------------
  
  
  
  
  
  // FOR 100EMA CROSSING 200EMA................................................................
  if(ma100>ma200 && ma100Prev<ma200Prev){
  
    
    //TO OPEN A BUY ORDER-------------------------------------------------------
      if(countBuy100and200==1&&openBuy100and200==0){
      
      
      //TO SEND THE MESSAGE
        string message = "100EMA has crossed 200EMA from below. A BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop100and200LossValue = Bid - StopLoss*vPoint;
      Stop100and200LossModifyBuy = Bid; //for check
      Take100and200ProfitValue = Bid + TakeProfit*vPoint;
      Take100and200ProfitCheck = Bid + TakeProfit*vPoint; //for check
      
     /* bool ress = OrderSelect(ticket100and200,SELECT_BY_TICKET);
      if(ress==true){
      OrderType();
         bool sell = OrderClose(ticket100and200, LotSize, Ask, 10);
         Alert("First 100ema and 200ema close sell ticket #", ticket100and200);
            if(sell==false){
            Alert("Error closing 100ema and 200ema sell");
            }
         
      }*/
      Alert (" 100and200 Very Strong Buy and stop loss: ", Stop100and200LossValue, " while take profit is: ", Take100and200ProfitValue, " on entry value: ", Bid);
      
      ticket100and200 = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 10, Stop100and200LossValue, Take100and200ProfitValue, "Buy 100and200 VeryStrong Order");
         Alert("successful 100ema and 200ema buy ticket", ticket100and200);
            if (ticket100and200 < 0){
               Alert("Error 100ema and 200ema sending ticket");
            }
      openBuy100and200 = 1;
      countBuy100and200++;
      countSell100and200 = 1;
      openSell100and200 = 0;
      }
      else{
      //Alert ("Strong buy not first");
      }
  }
  //100EMA AND 2OOEMA BUY FINISH-----------------------------------------------------
  
  
  
  
  
  //WHEN 100EMA CROSSES 200EMA FROM ABOVE------------------------------------------------
  if(ma100<ma200 && ma100Prev>ma200Prev){
  
  
    
    //TO OPEN A SELL ORDER-----------------------
      if(countSell100and200==1&&openSell100and200==0){
      
      
      //TO SEND THE MESSAGE
        string message = "100EMA has crossed 200EMA from above. A SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
     
     
  
      Stop100and200LossValue = Ask + StopLoss*vPoint;
      Stop100and200LossModifySell = Ask; //FOR CHECK
      Take100and200ProfitValue = Ask - TakeProfit*vPoint;
      Take100and200ProfitCheckSell = Ask - TakeProfit*vPoint; //FOR CHECK
      
      
       /* bool ressbuy = OrderSelect(ticket100and200,SELECT_BY_TICKET);
      if(ressbuy==true){
      OrderType();
         bool buy = OrderClose(ticket100and200, LotSize, Bid, 10);
         Alert("First 100 and 200ema close buy ticket #", ticket100and200);
            if(buy==false){
            Alert("Error closing 100ema and 200ema buy");
            }
         
      }*/
      
      Alert ("100ema and 200ema Very Strong Sell and stop loss: ", Stop100and200LossValue, " while take profit is: ", Take100and200ProfitValue, " on entry value: ", Ask);
      
          ticket100and200 = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 10, Stop100and200LossValue, Take100and200ProfitValue, "100ema and 200ema Very Sell Strong Order");
            Alert("successful 100ema and 200 ema sell ticket", ticket100and200);
            if (ticket100and200 < 0){
               Alert("Error sending 100ema and 200ema ticket");
            }
      openSell100and200 = 1;
      countSell100and200++;
      countBuy100and200 = 1;
      openBuy100and200 =0;
      }
      else{
      //Alert ("Strong Sell not first");
      }
  }
  //100EMA AND 200EMA SELL FINISH
  
  //-----------------------------------100EMA FINISHED--------------------------------------------------------------------------
  
  
  
  
  
  
  //-----------------------------------200EMA STARTED-----------------------------------------------------------------------------
  
   // FOR 10EMA CROSSING 200EMA................................................................
  if(ma10>ma200 && ma10Prev<ma200Prev){
  
    
    //TO OPEN A BUY ORDER-------------------------------------------------------
      if(countBuy10and200==1&&openBuy10and200==0){
      
      
      
      //TO SEND THE MESSAGE
       string message = "10EMA has crossed 200EMA from below. A BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop10and200LossValue = Bid - StopLoss*vPoint;
      Stop10and200LossModifyBuy = Bid; //for check
      Take10and200ProfitValue = Bid + TakeProfit*vPoint;
      Take10and200ProfitCheck = Bid + TakeProfit*vPoint; //for check
      
      /*bool ress = OrderSelect(ticket10and200,SELECT_BY_TICKET);
      if(ress==true){
      OrderType();
         bool sell = OrderClose(ticket10and200, LotSize, Ask, 10);
         Alert("First 10ema and 200ema close sell ticket #", ticket10and200);
            if(sell==false){
            Alert("Error closing 10ema and 200ema sell");
            }
         
      }*/
      Alert (" 10and200 Very Strong Buy and stop loss: ", Stop10and200LossValue, " while take profit is: ", Take10and200ProfitValue, " on entry value: ", Bid);
      
      ticket10and200 = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 10, Stop10and200LossValue, Take10and200ProfitValue, "Buy 10and200 VeryStrong Order");
         Alert("successful 10ema and 200ema buy ticket", ticket10and200);
            if (ticket10and200 < 0){
               Alert("Error 10ema and 200ema sending ticket");
            }
      openBuy10and200 = 1;
      countBuy10and200++;
      countSell10and200 = 1;
      openSell10and200 = 0;
      }
      else{
      //Alert ("Strong buy not first");
      }
  }
  //10EMA AND 2OOEMA BUY FINISH-----------------------------------------------------
  
  
  
  
  
  //WHEN 10EMA CROSSES 200EMA FROM ABOVE------------------------------------------------
  if(ma10<ma200 && ma10Prev>ma200Prev){
  
  
    //TO OPEN A SELL ORDER-----------------------
      if(countSell10and200==1&&openSell10and200==0){
      
      
      //TO SEND THE MESSAGE
       string message = "10EMA has crossed 200EMA from above. A SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop10and200LossValue = Ask + StopLoss*vPoint;
      Stop10and200LossModifySell = Ask; //FOR CHECK
      Take10and200ProfitValue = Ask - TakeProfit*vPoint;
      Take10and200ProfitCheckSell = Ask - TakeProfit*vPoint; //FOR CHECK
      
      
      /* bool ressbuy = OrderSelect(ticket10and200,SELECT_BY_TICKET);
      if(ressbuy==true){
      OrderType();
         bool buy = OrderClose(ticket10and200, LotSize, Bid, 10);
         Alert("First 10 and 200ema close buy ticket #", ticket10and200);
            if(buy==false){
            Alert("Error closing 10ema and 200ema buy");
            }
         
      }*/
      
      Alert ("10ema and 200ema Very Strong Sell and stop loss: ", Stop10and200LossValue, " while take profit is: ", Take10and200ProfitValue, " on entry value: ", Ask);
      
          ticket10and200 = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 10, Stop10and200LossValue, Take10and200ProfitValue, "10ema and 200ema Very Sell Strong Order");
            Alert("successful 10ema and 200 ema sell ticket", ticket10and200);
            if (ticket10and200 < 0){
               Alert("Error sending 10ema and 200ema ticket");
            }
      openSell10and200 = 1;
      countSell10and200++;
      countBuy10and200 = 1;
      openBuy10and200 =0;
      }
      else{
      //Alert ("Strong Sell not first");
      }
  }
  //10EMA AND 200EMA SELL FINISH------------------------------------------------------------------------------
  
 
 
 
  // FOR 20EMA CROSSING 200EMA................................................................
  if(ma20>ma200 && ma20Prev<ma200Prev){
  
    
    //TO OPEN A BUY ORDER-------------------------------------------------------
      if(countBuy200==1&&openBuy2==0){
      
      
      //TO SEND THE MESSAGE
       string message = "20EMA has crossed 200EMA from below. A BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop200LossValue = Bid - StopLoss*vPoint;
      Stop200LossModifyBuy = Bid; //for check
      Take200ProfitValue = Bid + TakeProfit*vPoint;
      Take200ProfitCheck = Bid + TakeProfit*vPoint; //for check
      
      /*bool ress = OrderSelect(ticket2,SELECT_BY_TICKET);
      if(ress==true){
      OrderType();
         bool sell = OrderClose(ticket2, LotSize, Ask, 10);
         Alert("First 20ema and 200ema close sell ticket #", ticket2);
            if(sell==false){
            Alert("Error closing sell");
            }
         
      }*/
      Alert ("Strong Buy and stop loss: ", Stop200LossValue, " while take profit is: ", Take200ProfitValue, " on entry value: ", Bid);
      
      ticket2 = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 10, Stop200LossValue, Take200ProfitValue, "Buy Strong Order");
         Alert("successful 20ema and 200ema buy ticket", ticket2);
            if (ticket2 < 0){
               Alert("Error 20ema and 200ema sending ticket");
            }
      openBuy2 = 1;
      countBuy200++;
      countSell200 = 1;
      openSell2 = 0;
      }
      else{
      //Alert ("Strong buy not first");
      }
  }
  //20EMA AND 200EMA BUY FINISH-----------------------------------------------------
  
  
  
  
  
  //WHEN 20EMA CROSSES 200EMA FROM ABOVE----------------------SELL--------------------------
  if(ma20<ma200 && ma20Prev>ma200Prev){
  
  
    //TO OPEN A SELL ORDER-----------------------
      if(countSell200==1&&openSell2==0){
      
      
      //TO SEND THE MESSAGE
       string message = "20EMA has crossed 200EMA from above. A SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
      
      Stop200LossValue = Ask + StopLoss*vPoint;
      Stop200LossModifySell = Ask; //FOR CHECK
      Take200ProfitValue = Ask - TakeProfit*vPoint;
      Take200ProfitCheckSell = Ask - TakeProfit*vPoint; //FOR CHECK
      
      
      /*  bool ressbuy = OrderSelect(ticket2,SELECT_BY_TICKET);
      if(ressbuy==true){
      OrderType();
         bool buy = OrderClose(ticket2, LotSize, Bid, 10);
         Alert("First 20 and 200ema close buy ticket #", ticket2);
            if(buy==false){
            Alert("Error closing 20ema and 200ema buy");
            }
         
      }*/
      
      Alert ("Strong Sell and stop loss: ", Stop200LossValue, " while take profit is: ", Take200ProfitValue, " on entry value: ", Ask);
      
          ticket2 = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 10, Stop200LossValue, Take200ProfitValue, "Sell Strong Order");
            Alert("successful 20ema and 200 ema sell ticket", ticket2);
            if (ticket2 < 0){
               Alert("Error sending 20ema and 200ema ticket");
            }
      openSell2 = 1;
      countSell200++;
      countBuy200 = 1;
      openBuy2 =0;
      }
      else{
      //Alert ("Strong Sell not first");
      }
  }
  //20EMA AND 200EMA SELL FINISH----------------------------------------------------------
  
  
  
  
  
  
  
  
  // FOR 50EMA CROSSING 200EMA................................................................
  if(ma50>ma200 && ma50Prev<ma200Prev){
  
    
   
    //TO OPEN A BUY ORDER-------------------------------------------------------
      if(countBuy50and200==1&&openBuy3==0){
      
      
      //TO SEND THE MESSAGE
       string message = "50EMA has crossed 200EMA from below. A BUY is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop50and200LossValue = Bid - StopLoss*vPoint;
      Stop50and200LossModifyBuy = Bid; //for check
      Take50and200ProfitValue = Bid + TakeProfit*vPoint;
      Take50and200ProfitCheck = Bid + TakeProfit*vPoint; //for check
      
      /*bool ress = OrderSelect(ticket3,SELECT_BY_TICKET);
      if(ress==true){
      OrderType();
         bool sell = OrderClose(ticket3, LotSize, Ask, 10);
         Alert("First 50ema and 200ema close sell ticket #", ticket3);
            if(sell==false){
            Alert("Error closing 50ema and 200ema sell");
            }
         
      }*/
      Alert (" 50and200 Very Strong Buy and stop loss: ", Stop50and200LossValue, " while take profit is: ", Take50and200ProfitValue, " on entry value: ", Bid);
      
      ticket3 = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 10, Stop50and200LossValue, Take50and200ProfitValue, "Buy 50and200 VeryStrong Order");
         Alert("successful 50ema and 200ema buy ticket", ticket3);
            if (ticket3 < 0){
               Alert("Error 50ema and 200ema sending ticket");
            }
      openBuy3 = 1;
      countBuy50and200++;
      countSell50and200 = 1;
      openSell3 = 0;
      }
      else{
      //Alert ("Strong buy not first");
      }
  }
  //50EMA AND 2OOEMA BUY FINISH-----------------------------------------------------
  
  
  
  
  
  //WHEN 50EMA CROSSES 200EMA FROM ABOVE------------------------------------------------
  if(ma50<ma200 && ma50Prev>ma200Prev){
  
    //TO OPEN A SELL ORDER-----------------------
      if(countSell50and200==1&&openSell3==0){
      
      
      //TO SEND THE MESSAGE
       string message = "50EMA has crossed 200EMA from above. A SELL is triggered on currency pair: "+string(Symbol())+" and time "+string(TimeCurrent());
       string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url = "https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=mg4agSmzVy42Z5f6DeJGYhNUrI1ddIIatcXKjNM21byE335IwAzGBo4CHvP9&from=Example&to=123456&body="+message;
  
//--- Reset the last error code
   ResetLastError();
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address
      MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
     Print("Success in WebRequest");
     }
     //SEND MESSAGE FINISHED
  
      Stop50and200LossValue = Ask + StopLoss*vPoint;
      Stop50and200LossModifySell = Ask; //FOR CHECK
      Take50and200ProfitValue = Ask - TakeProfit*vPoint;
      Take50and200ProfitCheckSell = Ask - TakeProfit*vPoint; //FOR CHECK
      
      
       /* bool ressbuy = OrderSelect(ticket3,SELECT_BY_TICKET);
      if(ressbuy==true){
      OrderType();
         bool buy = OrderClose(ticket3, LotSize, Bid, 10);
         Alert("First 50 and 200ema close buy ticket #", ticket3);
            if(buy==false){
            Alert("Error closing 50ema and 200ema buy");
            }
         
      }*/
      
      Alert ("50ema and 200ema Very Strong Sell and stop loss: ", Stop50and200LossValue, " while take profit is: ", Take50and200ProfitValue, " on entry value: ", Ask);
      
          ticket3 = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 10, Stop50and200LossValue, Take50and200ProfitValue, "50ema and 200ema Very Sell Strong Order");
            Alert("successful 50ema and 200 ema sell ticket", ticket3);
            if (ticket3 < 0){
               Alert("Error sending 50ema and 200ema ticket");
            }
      openSell3 = 1;
      countSell50and200++;
      countBuy50and200 = 1;
      openBuy3 =0;
      }
      else{
      //Alert ("Strong Sell not first");
      }
  }
  //50EMA AND 200EMA SELL FINISH
  
  //---------------------------------200EMA HAS FINISHED----------------------------------------------------------------------
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  else{
      //Alert("Do nothing");
  }
  
  }
//+------------------------------------------------------------------+
