package modules;


import snipe.slave.Server;
import snipe.slave.Module;
import snipe.lib.Params;


class VDLUserModule extends Module<VDLClient, ServerVDL>
{

  public var userPrepareFriend: Map<Int,Array<Int>>;
  public function new(srv: ServerVDL)
    {
      super(srv);
      name = "user";
      userPrepareFriend = new Map<Int,Array<Int>>();
    }

    public override function call(c: VDLClient, type: String, params: Params): Dynamic {
      var suc = UserCheckLogin(c, type);
      /*trace("+++++++++++++++++++++++++++++++++++++++++++++++++++");
      trace(type);
      trace("+++++++++++++++++++++++++++++++++++++++++++++++++++");*/
       var response = null;
        switch (type) {
          case "user.logout":
            response = UserLogout(c, params);
          case "user.data":
            response = UserData(c, params);
          case "user.ping":
            response = UserPing(c, params);
          case "user.searchEnemy":
            response = UserSearchEnemy(c, params);
          case "user.addFriend":
            response = UserFriends(c, params);
          case "user.deleteFriend":
            response = UserDelete(c, params);
          case "user.getAccessFriend":
            response = UserAccess(c, params);
          case "user.getFriendList":
            response = UserFriendList(c, params);
          case "user.addMoney":
            response = UserAddMoney(c, params);
          case "user.recovery":
            response = UserRecovery(c, params);




        }

      return response;
      }

      public function UserLogout(c: VDLClient, params: Params): Int {
        c.response('user.logout', {errorCode: 'ok'});
        server.disconnect(c);
        return 0;
      }

      public function UserData(c: VDLClient, params: Params): Dynamic {
        var userId = c.id;
        var money = c.get_money();
        var ret = server.cacheRequest({
           _type: "vdl/cache.user.getData",
           userId: userId,
           money: money
          });
        return ret;
      }

      public function UserAddMoney(c: VDLClient, params: Params): Dynamic {
        var userId = c.id;
        var count: Int = params.get("count");
        trace("+++++++++++++++++++++++++++++++++++++++++++++++++++");
        trace("addMoney: " + count + " curMoney: " + c.money);
        trace("+++++++++++++++++++++++++++++++++++++++++++++++++++");
        if(count == null) {
          return {errorCode: "expect count"};
        }
        /*if(count != "1" && count != "5" && count != "10" && count != "100") {
          return {errorCode: "wrong count"};
        }*/
        if(count != 1 && count != 5 && count != 10 && count != 100) {
          return {errorCode: "wrong count"};
        }
        var money = c.get_money();
        money += count;
        c.set_money(money);
        
        
        return {errorCode: "ok", money: money};
      }

      public function UserPing(c: VDLClient, params: Params): Dynamic {

        var msg: String = params.get("msg");
        trace( msg );

        return {errorCode: "ok"};
      }

      public function UserCheckLogin(c: VDLClient, type: String): Int {

        //var sendObj: Dynamic = (c.isLogin == true) ? { errorCode: "ok" } : { errorCode: 'notLogin' };
        var ret: Int = (c.isLogin == true) ? 0 : -1;
        if(c.isLogin == false) {
          c.response(type, { errorCode: 'notLogin' });
        }

        return ret;
      }

      public function UserSearchEnemy(c: VDLClient, params: Params): Dynamic {
        var name: String = params.get('name');
        var ret = server.cacheRequest({
           _type: "vdl/cache.user.searchEnemy",
           id: c.id,
           name: name
          });

        return {errorCode: "ok", list: ret.users };

      }
  
  public function UserRecovery(c: VDLClient, params: Params): Dynamic {
    
  }

      public function UserFriends(c: VDLClient, params: Params): Dynamic {
        var userId = params.get("userId");
        trace('===========================');
        trace('===========================');
        trace(userId, c.id);
        var type = params.get("type");
        var friendPrepareList = [];
        switch (type) {
          case "add":
            //friendPrepareList = userPrepareFriend.get(c.id);
            //if(friendPrepareList == null) friendPrepareList = [];
            //friendPrepareList.push(userId);
            FriendAdd(c.id, userId, "prepare");
            server.sendTo(userId, {
               player: c.id,
               _type: "user.friendAccess"
              });
          case "access":
            //friendPrepareList = userPrepareFriend.get(userId);
            //friendPrepareList.remove(c.id);
            FriendAdd(c.id, userId, "add");
            //FriendAdd(userId, c.id, "add");
            server.sendTo(c.id, {
               player: userId,
               _type: "user.friendAdd"
              });
          case "denied":
            //friendPrepareList = UserAccess(c.id, param);
            //trace('==================================');
            //trace(friendPrepareList);
            //arr = friendPrepareList.list;
            //arr.remove(userId);
  
            FriendAdd(c.id, userId, "denied");
            server.sendTo(userId, {
               player: c.id,
               _type: "user.friendDenied"
              });
        }

        return {errorCode: "ok"};

      }

      public function UserDelete(c: VDLClient, params: Params): Dynamic {
          var userId: Int = params.get('userId');
          var player: Int = c.id;
          
          var ret = server.cacheRequest({
                    _type: "vdl/cache.user.deleteFriend",
                    player: player,
                    friend: userId
                  });
          
          return ret;
        }

        public function UserAccess(c: VDLClient, params: Params): Dynamic {
          var ret = server.cacheRequest({
            _type: "vdl/cache.user.getAccessFriend",
            player: c.id
          });

          return ret;
        }

        public function UserFriendList(c: VDLClient, params: Params): Dynamic {
          var ret = server.cacheRequest({
                    _type: "vdl/cache.user.getFriendList",
                    player: c.id
                  });

                  return ret;
        }

      public function FriendAdd(player: Int, friend: Int, type: String): Dynamic {
        var ret = server.cacheRequest({
            _type: "vdl/cache.user.addFriend",
            player: player,
            friend: friend,
            type: type
          });
        return {}
      }

      public function UserRewrite(c: VDLClient, params: Params): Dynamic {
        var city: String = params.get('city');
        var year: String = params.get('year');
        var email: String = params.get('email');

        var ret = server.cacheRequest({
           _type: "vdl/cache.user.editProfile",
           id: c.id,
          city: city,
          email: email,
          year: year
          });

          return { errorCode: "ok", city: city, email: email, year: year };
      }

    



}
