using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

namespace Hotfix
{
    public interface IState
    {
        void OnEnter();

        void OnExit();

        void OnStateChange(string newState);

        void Update();

        void FixedUpdate();

        string Name { get; }

        string HierachicalName { get; }

        string OwnerName { get; }
    }

    public class State<T> : IState where T : IILManager
    {
        protected string name;
        protected T owner;
        protected HierarchicalStateMachine hsm;

        public State(T owner, HierarchicalStateMachine hsm)
        {
            this.owner = owner;
            this.hsm = hsm;
            this.name = GetType().Name;
        }

        public State(T owner, HierarchicalStateMachine hsm, string name)
        {
            this.owner = owner;
            this.hsm = hsm;
            this.name = name;
        }

        public override string ToString()
        {
            return name;
        }

        #region IState Members

        public virtual void OnEnter()
        {
        }

        public virtual void OnExit()
        {
        }

        public virtual void Update()
        {
        }

        public virtual void FixedUpdate()
        {
        }

        public void OnStateChange(string newState)
        {
            throw new NotImplementedException();
        }

        public string Name
        {
            get
            {
                return name;
            }
        }

        public string HierachicalName
        {
            get
            {
                return Name;
            }
        }

        public string OwnerName
        {
            get
            {
                return owner.GetType().Name;
            }
        }

        #endregion
    }

    public class CompositeState<T> : IState where T : IILManager
    {
        protected string name;
        protected T owner;
        protected HierarchicalStateMachine hsm;

        protected Dictionary<string, IState> nameDictionary;
        protected string defaultState;
        protected IState currentState;

        public IState CurrentState
        {
            get
            {
                return currentState;
            }
        }

        public CompositeState(T owner, HierarchicalStateMachine hsm)
        {
            this.owner = owner;
            this.hsm = hsm;
            this.name = GetType().Name;
        }

        public CompositeState(T owner, HierarchicalStateMachine hsm, string name)
        {
            this.owner = owner;
            this.hsm = hsm;
            this.name = name;
        }

        public override string ToString()
        {
            return HierachicalName;
        }

        protected void Init(List<IState> states, string defaultState)
        {
            // create name dictionary
            nameDictionary = new Dictionary<string, IState>();
            for (int i = 0; i < states.Count; i++)
            {
                nameDictionary.Add(states[i].Name, states[i]);
            }

            this.defaultState = defaultState;
        }

        public IState GetStateByName(string stateName)
        {
            if (nameDictionary.ContainsKey(stateName))
            {
                return nameDictionary[stateName];
            }

            return null;
        }

        #region IState Members

        public virtual void OnEnter()
        {
            // set to default state
            currentState = GetStateByName(defaultState);
            if (currentState == null)
            {
                DebugHelper.LogError($"Invalid state name: {defaultState}");
            }

            if (hsm.enableDebug)
            {
                DebugHelper.Log($"{hsm.owner} CompositeState::OnEnter {currentState}");
            }

            currentState.OnEnter();
        }

        public virtual void OnExit()
        {
            currentState.OnExit();

            if (hsm.enableDebug)
            {
                DebugHelper.Log($"{hsm.owner}CompositeState::OnExit {currentState}");
            }

            currentState = null;
        }

        public void OnStateChange(string stateName)
        {
            if (currentState != null)
            {
                // exit current state
                currentState.OnExit();
            }

            // set new state
            IState newState = GetStateByName(stateName);
            if (newState == null)
            {
                DebugHelper.LogError($"Invalid state name: {stateName}");
            }

            if (hsm.enableDebug)
            {
                DebugHelper.Log($"{hsm.owner} Change sub state from {currentState} to {newState}");
            }

            currentState = newState;

            // enter new state
            currentState.OnEnter();
        }

        public virtual void Update()
        {
            if (currentState != null)
            {
                // update current state
                currentState.Update();
            }
        }

        public virtual void FixedUpdate()
        {
            if (currentState != null)
            {
                // update current state
                currentState.FixedUpdate();
            }
        }

        public bool IsCompositeState
        {
            get
            {
                return true;
            }
        }

        public string Name
        {
            get
            {
                return name;
            }
        }

        public string HierachicalName
        {
            get
            {
                if (currentState == null)
                {
                    return Name;
                }
                else
                {
                    return $"{this.Name}::{this.currentState.HierachicalName}";
                }
            }
        }

        public string OwnerName
        {
            get
            {
                return owner.GetType().Name;
            }
        }

        #endregion
    }

    public class HierarchicalStateMachine
    {
        public bool enableDebug;
        public GameObject owner;

        private IState currentState;
        private IState previousState;
        private Dictionary<string, IState> nameDictionary;
        private string pendingStateChange;
        private bool currentOverwriteFlag;

        public event Action<string, string> StateChanged;

        public IState CurrentState
        {
            get
            {
                return currentState;
            }
        }

        public IState PreviousState
        {
            get
            {
                return previousState;
            }
        }

        public string CurrentStateName
        {
            get
            {
                return currentState.HierachicalName;
            }
        }

        public string PreviousStateName
        {
            get
            {
                return previousState.HierachicalName;
            }
        }

        public HierarchicalStateMachine(bool enableDebug, GameObject owner)
        {
            this.enableDebug = enableDebug;
            this.owner = owner;
            currentOverwriteFlag = true;
        }

        public void Init(List<IState> states, string defaultState)
        {
            // create name dictionary
            nameDictionary = new Dictionary<string, IState>();
            for (int i = 0; i < states.Count; i++)
            {
                nameDictionary.Add(states[i].Name, states[i]);
            }

            // to default state
            DoChangeState(defaultState);
        }

        public void Update()
        {
            // handle change state
            if (pendingStateChange != null)
            {
                DoChangeState(pendingStateChange);

                // clean state
                pendingStateChange = null;
            }

            // reset flag
            currentOverwriteFlag = true;

            // update current state
            currentState.Update();
        }

        public void FixedUpdate()
        {
            currentState?.FixedUpdate();
        }

        private void DoChangeState(string stateName)
        {
            // save previous state
            previousState = currentState;
            string[] names = stateName.Split(new string[] { "::" }, StringSplitOptions.RemoveEmptyEntries);

            if (names.Length == 1)
            {
                if (currentState != null)
                {
                    // exit current state
                    currentState.OnExit();
                }

                // set new state
                IState newState = GetStateByName(stateName);
                if (newState == null)
                {
                    DebugHelper.LogError($"Invalid state name: {stateName}");
                }

                if (enableDebug)
                {
                    DebugHelper.Log($"{owner} Change state from {currentState} to {newState}");
                }

                currentState = newState;

                // enter new state
                currentState.OnEnter();
            }
            else if (names.Length == 2)
            {
                // composite state
                string parentStateName = names[0];

                // find parent state
                IState parentState = GetStateByName(parentStateName);
                if (parentState == null)
                {
                    DebugHelper.LogError($"Invalid state name: {parentStateName}");
                }

                // check if parent state is current state
                if (parentState != currentState)
                {
                    // exit current state
                    currentState.OnExit();

                    // warning
                    DebugHelper.LogWarning($"Transfer to internal state {currentState.Name}");
                }

                // let state to handle it
                string subStateName = names[1];
                parentState.OnStateChange(subStateName);
            }
            else
            {
                DebugHelper.LogError($"{owner} Invalid state name: {stateName}");
            }

            if (StateChanged != null)
            {
                StateChanged(previousState.HierachicalName, currentState.HierachicalName);
            }

            DebugHelper.LogWarning($"{currentState.OwnerName}:{currentState.Name}");
        }

        public void CleanPendingState()
        {
            pendingStateChange = null;
            currentOverwriteFlag = true;
        }

        public void ForceChangeState(string stateName)
        {
            DoChangeState(stateName);

            // reset flag
            pendingStateChange = null;
            currentOverwriteFlag = true;
        }

        public void ChangeState(string stateName, bool overwriteFlag = true)
        {
            // check current flag
            if (currentOverwriteFlag)
            {
                // enable overwrite
                if (pendingStateChange != null && enableDebug)
                {
                    DebugHelper.LogWarning($"{owner} ChangeState will replace state {pendingStateChange} with {stateName}");
                }

                pendingStateChange = stateName;
            }
            else
            {
                // disable overwrite
                if (pendingStateChange != null)
                {
                    if (enableDebug)
                    {
                        DebugHelper.LogWarning($"{owner} Reject state changing from {pendingStateChange} to {stateName}");
                    }

                    return;
                }

                pendingStateChange = stateName;
            }

            // save flag
            currentOverwriteFlag = overwriteFlag;
        }

        public IState GetStateByName(string stateName)
        {
            if (nameDictionary.ContainsKey(stateName))
            {
                return nameDictionary[stateName];
            }

            return null;
        }

        public bool In(params string[] stateNames)
        {
            for (int i = 0; i < stateNames.Length; i++)
            {
                if (currentState.Name == stateNames[i])
                {
                    return true;
                }
            }

            return false;
        }

        public bool In(string stateName)
        {
            if (currentState.Name == stateName)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool In(string stateNameA, string stateNameB)
        {
            if (currentState.Name == stateNameA)
            {
                return true;
            }

            if (currentState.Name == stateNameB)
            {
                return true;
            }

            return false;
        }

        public bool In(string stateNameA, string stateNameB, string stateNameC)
        {
            if (currentState.Name == stateNameA)
            {
                return true;
            }

            if (currentState.Name == stateNameB)
            {
                return true;
            }

            if (currentState.Name == stateNameC)
            {
                return true;
            }

            return false;
        }

        public bool In(string stateNameA, string stateNameB, string stateNameC, string stateNameD)
        {
            if (currentState.Name == stateNameA)
            {
                return true;
            }

            if (currentState.Name == stateNameB)
            {
                return true;
            }

            if (currentState.Name == stateNameC)
            {
                return true;
            }

            if (currentState.Name == stateNameD)
            {
                return true;
            }

            return false;
        }

        public bool In(string stateNameA, string stateNameB, string stateNameC, string stateNameD, string stateNameE)
        {
            if (currentState.Name == stateNameA)
            {
                return true;
            }

            if (currentState.Name == stateNameB)
            {
                return true;
            }

            if (currentState.Name == stateNameC)
            {
                return true;
            }

            if (currentState.Name == stateNameD)
            {
                return true;
            }

            if (currentState.Name == stateNameE)
            {
                return true;
            }

            return false;
        }
    }
}