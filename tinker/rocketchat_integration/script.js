class Script {

    process_incoming_request({ request }) {

      content = request.content

      dataToPrint = {
        "event_name": content.event_name,
        "branch": content.ref,
        "project_repo": content.repository.name,
        "changes": content.commits
      }
  
  
      return {
        content:{
          text: JSON.stringify(dataToPrint, undefined, 4)
         }
      };
  
    }
}