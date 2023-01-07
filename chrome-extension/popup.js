function sendScrapeMsg() {
  chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
    // Finds tabs that are active in the current window
    console.log(tabs);
    chrome.tabs.sendMessage(tabs[0].id, { action: "scrapeamazon" }, (data) => {
      console.log(data);
      const select = document.getElementById("subscription_plan_id");
      const option = Array.from(select.children).find((option) =>
        option.innerText.includes(data.plan)
      );
      select.value = option.value;
      const renewalInput = document.getElementById("subscription_renewal_date");
      const tzoffset = new Date().getTimezoneOffset() * 60000; //offset in milliseconds
      renewalInput.value = new Date(new Date(data.endDate) - tzoffset)
        .toISOString()
        .split("T")[0];
    }); // Sends a message (object) to the first tab (tabs[0])
  });
}

// get service name from the website
function getUrl() {
  return new Promise((resolve, reject) => {
    try {
      chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
        resolve(tabs[0].url);
      });
    } catch (e) {
      reject(e);
    }
  });
}

function getTitle() {
  return new Promise((resolve, reject) => {
    try {
      chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
        resolve(tabs[0].title);
      });
    } catch (e) {
      reject(e);
    }
  });
}

function getResource(title) {
  const titleLower = title.toLowerCase();
  return new Promise((resolve, reject) => {
    try {
      fetch("http://www.substracked.com/api/v1/resources")
        .then((response) => response.json())
        .then((data) => {
          const preResources = data.filter(
            (service) => service.user_id === null
          );
          console.log(preResources);
          let resource = preResources.find((service) =>
            titleLower.includes(service.name.toLowerCase())
          );
          if (title.includes("Amazon")) {
            resource = preResources.find(
              (service) => service.name === "Amazon Prime"
            );
          }
          resolve(resource);
        });
    } catch (e) {
      reject(e);
    }
  });
}

// function fetchData(resource) {
//   const select = document.getElementById("subscription_plan_id");
//   fetch("http://www.substracked.com/api/v1/resources")
//     .then((response) => response.json())
//     .then((dataResources) => {
//       let targetResourceID = dataResources.find(
//         (dataResource) => dataResource.name === resource.name
//       ).id;
//       fetch("http://www.substracked.com/api/v1/plans")
//         .then((response) => response.json())
//         .then((dataPlans) => {
//           select.innerHTML = "";
//           let targetPlans = dataPlans.filter(
//             (dataPlan) => dataPlan.resource_id === targetResourceID
//           );
//           let selectOptions;
//           if (targetPlans[0].name === "") {
//             selectOptions += `<option value="${targetPlans[0].id}">N/A</option>`;
//           } else {
//             targetPlans.forEach((plan) => {
//               selectOptions += `<option value="${plan.id}">${plan.name} - ¥ ${plan.price}</option>`;
//             });
//           }
//           select.insertAdjacentHTML("beforeend", selectOptions);
//           sendScrapeMsg();
//         });
//     });
// }

// a button to add subs after the user filled the form
async function addSubs() {
  let title = await getTitle();
  document.getElementById("bookmark_name").value = title;
  let url = await getUrl();
  document.getElementById("bookmark_url").value = url;
  const button = document.getElementById("send-data");
  button.addEventListener("click", (e) => {
    const base_url = "http://localhost:3000/api/v1/bookmarks";
    const name = document.getElementById("bookmark_name").value;
    const bookmark_url = document.getElementById("bookmark_url").value;
    const video = document.getElementById("bookmark_video").value;
    fetch(base_url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        bookmark: {
          name: name,
          url: bookmark_url,
          video: video,
        },
      }),
    });
    alert("Bookmark added!");
  });
}
addSubs();

const logout = document.getElementById("logout");
logout.addEventListener("mouseover", (event) => {
  event.target.classList.remove("text-secondary");
  event.target.classList.add("text-dark");
});

logout.addEventListener("mouseout", (event) => {
  event.target.classList.remove("text-dark");
  event.target.classList.add("text-secondary");
});
