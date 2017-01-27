package modules;

import snipe.edit.Vars;

class Gamer extends snipe.edit.ModuleEdit<ServerVDL>
{
  public function new(s: ServerVDL)
    {
      super(s);
      name = "gamer";
      exports = [
	  
	  {
          action: "gamer.list",
          title: "Игроки",
          blocks: [
            {
              type: BLOCK_LIST,
			  title: "Игроки",
              actionPre: "gamer.",
			  actions: [ "edit", "del" ],
              query: "SELECT * " +
                    "FROM users WHERE isbanned = 'false' ORDER BY id",
              fields: [ 'id', 'name', 'email']
            }]
      },
	  {
          action: "gamer.del",
          table: "Gamers",
          delete: true,
          back: "gamer.list"
      },
	{
          action: "gamer.edit",
          title: "Gamers",
          back: "gamer.list",
          blocks: [
            {
              type: BLOCK_FORM,
              title: "Gamers parameters",
              action: "gamer.update",
              query: "SELECT name, email FROM users WHERE id = [id]",
              inputs: [
                { title: "Имя", name: "name" },
				{ title: "E-mail", name: "email" },
				{ title: "Забанить пользователя", name: "isbanned", type: INPUT_SELECT, 
                  values: [ 
                    { name: "Нет", value: 'false' },
					{ name: "Да", value: 'true' },
					] 					
				},
				]
			},
		 ]

	},
		
	 {
          action: "gamer.update",
          back: "gamer.list",
          isMethod: true
     },
   ];
  }
	
	function del(vars: Vars)
    {
      var id = vars.getInt('id');

      server.query("DELETE FROM users WHERE ID = " + id);
    }
	
	 function update(vars: Vars)
    {

	  var id = vars.getInt('id');
      var name = server.quote(vars.getString('name'));
      var email = server.quote(vars.getString('email'));
	  var isbanned = server.quote(vars.getString('isbanned'));
	
      server.query("UPDATE users SET " +
        "name = " + name +
        ", email = " + email + 
		", isbanned = " + isbanned + " WHERE ID = " + id);
		
	
    }
	
	
}