package modules;

import snipe.edit.Vars;

class Security extends snipe.edit.ModuleEdit<ServerVDL>
{
  public function new(s: ServerVDL)
    {
      super(s);
      name = "security";
      exports = [
	  
	  {
          action: "security.list",
          title: "Защищенные турниры",
          blocks: [
		  {
              type: BLOCK_LIST,
			  title: "Список разовыых турниров",
              actionPre: "security.",
			  actions: [ "edit", "del" ],
              query: "SELECT * " +
                    "FROM tournament WHERE type='security' ORDER BY id",
              fields: [ 'name', 'startdate', 'rounddate', 'roundtime', 'roundinterval', 'passwordtournament' ]
            },
			 {
              type: BLOCK_FORM,
              title: "Добавить турнир",
              action: "security.add",
              inputs: [
				{ title: "Наименование турнира", name: "name" },
                { title: "Дата турнира", name: "startdate",
					type: INPUT_DATETIME },
				{ title: "Дата следующего раунда", name: "rounddate",
					type: INPUT_DATETIME },
				{ title: "Длительность раунда", name: "roundtime", type: INPUT_SELECT, 
                  values: [ 
                    { name: "30", value: '30' },
                    { name: "60", value: '60' },
                    { name: "90", value: '90' },
                    ] },
				{ title: "Интервал между раундами", name: "roundinterval", type: INPUT_SELECT, 
                  values: [ 
                    { name: "15", value: '15' },
                    { name: "30", value: '30' },
                    { name: "45", value: '45' },
                ] },
				{ title: "Пароль", name: "passwordtournament" },
             ] 
			}
              ]
        },
		{
          action: "security.add",
          isMethod: true,
          back: "security.list"
        },
		{
          action: "security.del",
          table: "Tournament",
          delete: true,
          back: "security.list"
		},
		{
          action: "security.edit",
          title: "Tournament",
          back: "security.list",
          blocks: [
            {
              type: BLOCK_FORM,
              title: "Tournaments parameters",
              action: "security.update",
              query: "SELECT * FROM Tournament WHERE ID = [id]",
              inputs: [
               { title: "Наименование турнира", name: "name" },
                { title: "Дата турнира", name: "startdate",
					type: INPUT_DATETIME },
				{ title: "Дата следующего раунда", name: "rounddate",
					type: INPUT_DATETIME },
				{ title: "Длительность раунда", name: "roundtime", type: INPUT_SELECT, 
                  values: [ 
                    { name: "30", value: '30' },
                    { name: "60", value: '60' },
                    { name: "90", value: '90' },
                    ] },
				{ title: "Интервал между раундами", name: "roundinterval", type: INPUT_SELECT, 
                  values: [ 
                    { name: "15", value: '15' },
                    { name: "30", value: '30' },
                    { name: "45", value: '45' },
                ] },
				{ title: "Пароль", name: "passwordtournament" },
              ]
			},
		]
	  },
	  {
          action: "security.update",
          back: "security.list",
          isMethod: true
      },
		
		];
      }
	  	
	function add(vars: Vars)
    {
      var name = server.quote(vars.getString('name'));
      var startdate = vars.getTypedSQL('datetime:startdate').val;
      var rounddate = vars.getTypedSQL('datetime:rounddate').val;
	  var roundtime = vars.getInt('roundtime');
	  var roundinterval = vars.getInt('roundinterval');
	  var passwordtournament = vars.getInt('passwordtournament');
      server.query("INSERT INTO Tournament (name, startdate, rounddate, roundtime, roundinterval, passwordtournament, type)" +
        "VALUES (" + name + "," + server.quote(startdate) + "," + server.quote(rounddate) + "," + roundtime + "," + roundinterval + "," + passwordtournament + "," + server.quote("security") + ")");
    }	
	
	function del(vars: Vars)
    {
      var id = vars.getInt('id');

      server.query("DELETE FROM Tournament WHERE ID = " + id);
    }
	
	 function update(vars: Vars)
    {
      var id = vars.getInt('id');
      var name = server.quote(vars.getString('name'));
      var startdate = vars.getTypedSQL('datetime:startdate').val;
      var rounddate = vars.getTypedSQL('datetime:rounddate').val;
	  var roundtime = vars.getInt('roundtime');
	  var roundinterval = vars.getInt('roundinterval');
	  var repeatinterval = vars.getInt('repeatinterval');
	  var passwordtournament = vars.getInt('passwordtournament');
	  	  
      server.query("UPDATE Tournament SET " +
        "name = " + name +
        ", startdate = " + server.quote(startdate) + 
        ", rounddate = " + server.quote(rounddate) + 
		", roundtime = " + roundtime + 
		", roundinterval = " + roundinterval + 
		", passwordtournament = " + passwordtournament +" WHERE ID = " + id);
    }
}