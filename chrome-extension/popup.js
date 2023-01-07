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

async function addBookmark() {
  let title = await getTitle();
  document.getElementById("bookmark_name").value = title;
  let url = await getUrl();
  document.getElementById("bookmark_url").value = url;
  const button = document.getElementById("send-data");
  chrome.storage.sync.get(["token"], function (result) {
    const token = result.token;
    console.log(token);
    button.addEventListener("click", (e) => {
      const base_url = "http://localhost:3000/api/v1/bookmarks";
      const name = document.getElementById("bookmark_name").value;
      const bookmark_url = document.getElementById("bookmark_url").value;
      const video = document.getElementById("bookmark_video").value;
      fetch(base_url, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
          Accept: "application/json",
        },
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
  });
}
addBookmark();

const logout = document.getElementById("logout");
logout.addEventListener("mouseover", (event) => {
  event.target.classList.remove("text-secondary");
  event.target.classList.add("text-dark");
});

logout.addEventListener("mouseout", (event) => {
  event.target.classList.remove("text-dark");
  event.target.classList.add("text-secondary");
});

function login() {
  let email = document.getElementById("email").value;
  let password = document.getElementById("password").value;
  var myInit = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ email: email, password: password }),
  };
  // fetch("http://www.jobjob.pro/api/v1/auth/login", myInit)
  fetch("http://localhost:3000/api/v1/auth/login", myInit)
    .then((response) => {
      return response.json();
    })
    .then((data) => {
      console.log(data);
      chrome.storage.sync.set(data, function () {
        console.log("Value is set to " + data);
        document.getElementById("showSignIn").style.display = "none";
      });
    });
}

document.getElementById("login-form").addEventListener("submit", (event) => {
  event.preventDefault();
  login();
});

console.log(chrome.storage);
chrome.storage.sync.get(["token"], function (result) {
  console.log(result);
  if (result.token) {
    document.getElementById("showSignIn").style.display = "none";
  }
});
