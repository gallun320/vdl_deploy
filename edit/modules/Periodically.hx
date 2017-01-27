package modules;

import snipe.edit.Vars;

class Periodically extends snipe.edit.ModuleEdit<ServerVDL>
{
  public function new(s: ServerVDL)
    {
      super(s);
      name = "periodically";
      exports = [
	  
	  {
          action: "periodically.list",
          title: "Периодические турниры",
          blocks: [
		  {
              type: BLOCK_LIST,
			  title: "Список разовыых турниров",
              actionPre: "periodically.",
			  actions: [ "edit", "del" ],
              query: "SELECT * " +
                    "FROM tournament WHERE type='periodically' ORDER BY id",
              fields: [ 'name', 'startdate', 'rounddate', 'roundtime', 'roundinterval', 'repeatinterval' ]
            },
			 {
              type: BLOCK_FORM,
              title: "Добавить турнир",
              action: "periodically.add",
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
				{ title: "Периодичность турнира", name: "repeatinterval", type: INPUT_SELECT, 
                  values: [ 
                    { name: "Раз в неделю", value: '168' },
                    { name: "Раз в две недели", value: '336' },
                    { name: "Раз в месяц", value: '672' },
					{ name: "Раз в 3 месяца", value: '2016' },
					{ name: "Раз в полгода", value: '4032' },
					{ name: "Раз в год", value: '8064' },
                ] }
              ]
            }]
      },
	  	 {
          action: "periodically.add",
          isMethod: true,
          back: "periodically.list"
        },
		 {
          action: "periodically.del",
          table: "Tournament",
          delete: true,
          back: "periodically.list"
		},
		{
          action: "periodically.edit",
          title: "Tournament",
          back: "periodically.list",
          blocks: [
            {
              type: BLOCK_FORM,
              title: "Tournaments parameters",
              action: "periodically.update",
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
				{ title: "Периодичность турнира", name: "repeatinterval", type: INPUT_SELECT, 
                  values: [ 
                    { name: "Раз в неделю", value: '168' },
                    { name: "Раз в две недели", value: '336' },
                    { name: "Раз в месяц", value: '672' },
					{ name: "Раз в 3 месяца", value: '2016' },
					{ name: "Раз в полгода", value: '4032' },
					{ name: "Раз в год", value: '8064' },
                ] }
              ]
			},
		]
	  },
	  {
          action: "periodically.update",
          back: "periodically.list",
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
	  var repeatinterval = vars.getInt('repeatinterval');
      server.query("INSERT INTO Tournament (name, startdate, rounddate, roundtime, roundinterval, repeatinterval, type)" +
        "VALUES (" + name + "," + server.quote(startdate) + "," + server.quote(rounddate) + "," + roundtime + "," + roundinterval + "," + repeatinterval + "," + server.quote("periodically") + ")");
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
	  	  
      server.query("UPDATE Tournament SET " +
        "name = " + name +
        ", startdate = " + server.quote(startdate) + 
        ", rounddate = " + server.quote(rounddate) + 
		", roundtime = " + roundtime + 
		", roundinterval = " + roundinterval + 
		", repeatinterval = " + repeatinterval +" WHERE ID = " + id);
    }
	
}