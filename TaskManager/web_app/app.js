// State Management for StudentConnect Demo App
let state = {
  currentNav: 'home',
  currentTab: 'assigned',
  selectedProjectId: 1,
  teammateChips: ['sarah@university.edu', 'david@university.edu'],
  projects: [
    {
      id: 1,
      name: "Final Year Capstone",
      description: "Students often struggle to find teammates and manage academic projects. The application enables project creation, team formation, task assignment, progress tracking, and project documentation.",
      lead: "Alex Morgan",
      date: "17/08/2026",
      members: ["alex@university.edu", "sarah@university.edu", "david@university.edu"],
      color: "indigo"
    },
    {
      id: 2,
      name: "AI Study Group Platform",
      description: "Collaborative machine learning model training and dataset sharing portal for computer science students.",
      lead: "Alex Morgan",
      date: "10/08/2026",
      members: ["alex@university.edu", "elena@university.edu"],
      color: "teal"
    },
    {
      id: 3,
      name: "Mobile UI Design System",
      description: "Figma design system and Flutter component library tailored for academic collaboration projects.",
      lead: "Alex Morgan",
      date: "05/08/2026",
      members: ["alex@university.edu", "jordan@university.edu", "chris@university.edu"],
      color: "purple"
    }
  ],
  tasks: [
    {
      id: 101,
      projectId: 1,
      name: "UI Wireframing & Design System",
      description: "Design mobile wireframes for Project Creation and Documentation screens.",
      date: "18/08/2026",
      time: "14:00",
      assignee: "sarah@university.edu",
      status: "assigned"
    },
    {
      id: 102,
      projectId: 1,
      name: "Firestore Database Integration",
      description: "Set up projectTasks sub-collections and real-time streams.",
      date: "19/08/2026",
      time: "16:30",
      assignee: "alex@university.edu",
      status: "inProgress"
    },
    {
      id: 103,
      projectId: 1,
      name: "Team Formation & Invite Emails",
      description: "Configure SendEmail service for inviting project members.",
      date: "15/08/2026",
      time: "11:00",
      assignee: "david@university.edu",
      status: "completed"
    },
    {
      id: 104,
      projectId: 2,
      name: "Dataset Preprocessing Pipeline",
      description: "Clean CSV data and generate TFRecord files.",
      date: "20/08/2026",
      time: "18:00",
      assignee: "elena@university.edu",
      status: "assigned"
    }
  ],
  docs: [
    {
      id: 201,
      projectId: 1,
      title: "SRS Document & Requirements Specification",
      content: "Students often struggle to find teammates and manage academic projects. The application enables project creation, team formation, task assignment, progress tracking, and project documentation.",
      author: "Alex Morgan",
      date: "17/08/2026 14:30"
    },
    {
      id: 202,
      projectId: 1,
      title: "Team Meeting Minutes - Sprint 1",
      content: "Agreed on Flutter frontend with Firebase Firestore backend architecture. Assigned UI tasks to Sarah and backend pipelines to Alex.",
      author: "Sarah Jenkins",
      date: "16/08/2026 10:15"
    }
  ]
};

// Initialize App
document.addEventListener('DOMContentLoaded', () => {
  renderProjects();
  renderTasks();
  renderTeammateChips();
});

// Navigation Handler
function switchNav(navId) {
  state.currentNav = navId;
  
  // Hide all views
  document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
  document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));

  // Show target view
  const targetView = document.getElementById(`view-${navId}`);
  if (targetView) targetView.classList.add('active');

  // Update Nav bar active item
  const navBtnIndex = { 'home': 0, 'create-project': 1, 'all-projects': 2, 'notifications': 3 }[navId];
  if (navBtnIndex !== undefined) {
    document.querySelectorAll('.nav-item')[navBtnIndex].classList.add('active');
  }

  if (navId === 'all-projects') renderAllProjectsGrid();
  if (navId === 'project-details') renderProjectDetails();
  if (navId === 'documentation') renderDocumentation();
}

// Render Projects Horizontal Slider
function renderProjects() {
  const container = document.getElementById('projectsSlider');
  container.innerHTML = state.projects.map(p => {
    const projTasks = state.tasks.filter(t => t.projectId === p.id);
    const completedTasks = projTasks.filter(t => t.status === 'completed');
    const progress = projTasks.length > 0 ? Math.round((completedTasks.length / projTasks.length) * 100) : 0;

    return `
      <div class="project-card ${p.color}" onclick="openProjectDetails(${p.id})">
        <div>
          <div class="project-title">${escapeHtml(p.name)}</div>
          <div class="project-meta">📅 ${p.date}</div>
        </div>
        <div class="project-footer">
          <div class="team-avatars">
            ${p.members.slice(0, 3).map(m => `<div class="team-avatar">${m[0].toUpperCase()}</div>`).join('')}
            ${p.members.length > 3 ? `<div class="team-avatar">+${p.members.length - 3}</div>` : ''}
          </div>
          <div class="progress-pill">${progress}% Done</div>
        </div>
      </div>
    `;
  }).join('');
}

// Render All Projects Grid
function renderAllProjectsGrid() {
  const container = document.getElementById('allProjectsGrid');
  container.innerHTML = state.projects.map(p => {
    const projTasks = state.tasks.filter(t => t.projectId === p.id);
    const completedTasks = projTasks.filter(t => t.status === 'completed');
    const progress = projTasks.length > 0 ? Math.round((completedTasks.length / projTasks.length) * 100) : 0;

    return `
      <div class="project-card ${p.color}" style="min-width: unset; height: 170px;" onclick="openProjectDetails(${p.id})">
        <div>
          <div class="project-title">${escapeHtml(p.name)}</div>
          <div class="project-meta">📅 ${p.date}</div>
        </div>
        <div class="project-footer">
          <div class="team-avatars">
            ${p.members.slice(0, 2).map(m => `<div class="team-avatar">${m[0].toUpperCase()}</div>`).join('')}
          </div>
          <div class="progress-pill">${progress === 100 ? 'Complete' : 'In Progress'}</div>
        </div>
      </div>
    `;
  }).join('');
}

// Filter & Render Tasks
function filterTasks(tabName, btnElement) {
  state.currentTab = tabName;
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  if (btnElement) btnElement.classList.add('active');
  renderTasks();
}

function renderTasks() {
  const container = document.getElementById('tasksList');
  const filtered = state.tasks.filter(t => t.status === state.currentTab);

  if (filtered.length === 0) {
    container.innerHTML = `<div style="text-align:center; padding: 24px; color: var(--text-muted);">No tasks in this category</div>`;
    return;
  }

  container.innerHTML = filtered.map(t => {
    const proj = state.projects.find(p => p.id === t.projectId) || { name: 'General' };
    let actionBtn = '';
    if (state.currentTab === 'assigned') {
      actionBtn = `<button class="status-btn in-progress" onclick="updateTaskStatus(${t.id}, 'inProgress')">Start Task →</button>`;
    } else if (state.currentTab === 'inProgress') {
      actionBtn = `<button class="status-btn complete" onclick="updateTaskStatus(${t.id}, 'completed')">Complete ✓</button>`;
    }

    return `
      <div class="task-tile">
        <div class="task-info">
          <div class="task-name">${escapeHtml(t.name)}</div>
          <div class="task-sub">📅 ${t.date} ${t.time} • ${escapeHtml(proj.name)}</div>
          <div class="task-sub" style="font-weight:600; color:var(--primary);">👤 ${escapeHtml(t.assignee)}</div>
        </div>
        <div class="task-actions">
          ${actionBtn}
        </div>
      </div>
    `;
  }).join('');
}

// Update Task Status
function updateTaskStatus(taskId, newStatus) {
  const task = state.tasks.find(t => t.id === taskId);
  if (task) {
    task.status = newStatus;
    renderTasks();
    renderProjects();
  }
}

// Create Project Handler
function addTeammateChip() {
  const emailInput = document.getElementById('inputTeammateEmail');
  const val = emailInput.value.trim();
  if (val && !state.teammateChips.includes(val)) {
    state.teammateChips.push(val);
    emailInput.value = '';
    renderTeammateChips();
  }
}

function removeTeammateChip(index) {
  state.teammateChips.splice(index, 1);
  renderTeammateChips();
}

function renderTeammateChips() {
  const container = document.getElementById('teammateChips');
  container.innerHTML = state.teammateChips.map((email, i) => `
    <span class="chip">${escapeHtml(email)} <span class="close" onclick="removeTeammateChip(${i})">×</span></span>
  `).join('');
}

function handleCreateProject() {
  const name = document.getElementById('inputProjName').value.trim();
  const desc = document.getElementById('inputProjDesc').value.trim();

  if (!name || !desc) {
    alert('Please fill out Project Name and Description');
    return;
  }

  const newProj = {
    id: Date.now(),
    name: name,
    description: desc,
    lead: "Alex Morgan",
    date: new Date().toLocaleDateString('en-GB'),
    members: ["alex@university.edu", ...state.teammateChips],
    color: ["indigo", "teal", "purple"][state.projects.length % 3]
  };

  state.projects.unshift(newProj);
  document.getElementById('inputProjName').value = '';
  document.getElementById('inputProjDesc').value = '';
  state.teammateChips = [];
  renderTeammateChips();
  renderProjects();
  switchNav('home');
}

// Open Project Details
function openProjectDetails(projId) {
  state.selectedProjectId = projId;
  switchNav('project-details');
}

function renderProjectDetails() {
  const proj = state.projects.find(p => p.id === state.selectedProjectId);
  if (!proj) return;

  document.getElementById('detailProjTitle').innerText = proj.name;
  document.getElementById('detailProjDate').innerText = proj.date;
  document.getElementById('detailProjLead').innerText = proj.lead;
  document.getElementById('detailProjDesc').innerText = proj.description;

  const projTasks = state.tasks.filter(t => t.projectId === proj.id);
  const container = document.getElementById('detailTasksList');

  if (projTasks.length === 0) {
    container.innerHTML = `<div style="text-align:center; padding:16px; color:var(--text-muted);">No tasks added yet</div>`;
  } else {
    container.innerHTML = projTasks.map(t => `
      <div class="task-tile">
        <div class="task-info">
          <div class="task-name">${escapeHtml(t.name)}</div>
          <div class="task-sub">Assigned to: ${escapeHtml(t.assignee)} • Deadline: ${t.date}</div>
        </div>
        <span class="badge ${t.status === 'completed' ? 'badge-teal' : 'badge-indigo'}">${t.status}</span>
      </div>
    `).join('');
  }
}

// Open Documentation
function openDocumentation() {
  switchNav('documentation');
}

function renderDocumentation() {
  const container = document.getElementById('docsList');
  const projDocs = state.docs.filter(d => d.projectId === state.selectedProjectId);

  if (projDocs.length === 0) {
    container.innerHTML = `<div style="text-align:center; padding:24px; color:var(--text-muted);">No documentation entries created yet</div>`;
    return;
  }

  container.innerHTML = projDocs.map(d => `
    <div class="doc-card">
      <div class="doc-header">
        <div class="doc-icon">📄</div>
        <div class="doc-title">${escapeHtml(d.title)}</div>
      </div>
      <div class="doc-body">${escapeHtml(d.content)}</div>
      <div class="doc-footer">
        <span>By: ${escapeHtml(d.author)}</span>
        <span>${d.date}</span>
      </div>
    </div>
  `).join('');
}

function handleAddDoc() {
  const title = document.getElementById('docTitle').value.trim();
  const content = document.getElementById('docContent').value.trim();

  if (!title || !content) {
    alert('Please provide both document title and content');
    return;
  }

  const newDoc = {
    id: Date.now(),
    projectId: state.selectedProjectId,
    title: title,
    content: content,
    author: "Alex Morgan",
    date: new Date().toLocaleDateString('en-GB') + ' ' + new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
  };

  state.docs.unshift(newDoc);
  document.getElementById('docTitle').value = '';
  document.getElementById('docContent').value = '';
  renderDocumentation();
}

// Modals Handler
function openAddTaskModal() {
  const proj = state.projects.find(p => p.id === state.selectedProjectId);
  const select = document.getElementById('selectTeammate');
  if (proj) {
    select.innerHTML = proj.members.map(m => `<option value="${m}">${m}</option>`).join('');
  }
  document.getElementById('modalAddTask').classList.add('active');
}

function handleAddTask() {
  const title = document.getElementById('inputTaskTitle').value.trim();
  const desc = document.getElementById('inputTaskDesc').value.trim();
  const date = document.getElementById('inputTaskDate').value;
  const time = document.getElementById('inputTaskTime').value;
  const assignee = document.getElementById('selectTeammate').value;

  if (!title || !desc) {
    alert('Please enter Task Title and Description');
    return;
  }

  const newTask = {
    id: Date.now(),
    projectId: state.selectedProjectId,
    name: title,
    description: desc,
    date: date || new Date().toLocaleDateString('en-GB'),
    time: time || '12:00',
    assignee: assignee,
    status: 'assigned'
  };

  state.tasks.unshift(newTask);
  closeModals();
  renderProjectDetails();
  renderTasks();
  renderProjects();
}

function openAddTeammateModal() {
  document.getElementById('modalAddTeammate').classList.add('active');
}

function handleAddTeammateDirect() {
  const email = document.getElementById('modalTeammateEmail').value.trim();
  if (email) {
    const proj = state.projects.find(p => p.id === state.selectedProjectId);
    if (proj && !proj.members.includes(email)) {
      proj.members.push(email);
    }
    document.getElementById('modalTeammateEmail').value = '';
    closeModals();
    renderProjectDetails();
    renderProjects();
  }
}

function closeModals() {
  document.querySelectorAll('.modal-overlay').forEach(m => m.classList.remove('active'));
}

function escapeHtml(str) {
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}
