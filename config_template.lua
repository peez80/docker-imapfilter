options.certificates = false


-- ------------------------------------------
-- Fill up to_regex and to_contains. Be aware that contains is much more faster than regex.
-- -----------

-- if true, no messages will be touched
dryrun = true

-- if true, only filter unread messages, if false filter all messages in folder
onlyunread = false

-- Search in each of these folders for patterns below
searchfolders = {
    'search-folder1',
    'anotherSearFolder'
}

-- Move found messages to this folder
targetfolder = 'folderToMoveMessagesTo'



-- search occurrence in recipient
to_contains = {
    'someEmail@address.com',
    'anotherEmail@something'
}

-- Match recipient to regex pattern
to_regex = {
    '^[Ff]irst [Rr]egex'
}

-- ------------------------------------------

-- Configure Mailbox. Variable name must stay "mbox"
mbox = IMAP {
    server = 'imap.provider.com',
    username = 'providersUsername',
    password = 'providersPassword',
    ssl = 'ssl23'
}
















-- ----------------------------------------------------------
-- Script Content.
-- If you use default behaviour nothing has to be changed from here on.
-- ----------------------------------------------------------


function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


-- Print some overview information
mbox.INBOX:check_status()
for i, sourcefolder in ipairs(searchfolders) do
    mbox[sourcefolder]:check_status()
end


-- Print some infos about folders of the mailbox ----------------------------------
print("Folders:")
mailboxes, folders = mbox:list_all()
table.foreach(mailboxes,print)
table.foreach(folders,print)
print("-----------------------------------------------------")
print("");

function findMessages(sourcefolder, pattern, method)
    local results = {}

    -- At first find all source messages (unseen or all)
    if onlyunread then
        results = mbox[sourcefolder]:is_unseen()
    else
        results = mbox[sourcefolder]:select_all()
    end

    -- Now filter
    if method == 'to_contains' then
        results = results:contain_to(pattern)
    elseif method == 'to_regex' then
        results = results:match_to(pattern)
    else
        error("Unknown method")
    end

    return results
end


function processMessages(sourcefolder, pattern, method, targetfolder)
    print('  Processing ' .. method .. ': ' .. pattern .. ':')
    local results = findMessages(sourcefolder, pattern, method)
    print('  Found ' .. tablelength(results) .. ' messages. Now moving to ' .. targetfolder .. '...')
    if not dryrun then
        results:move_messages(mbox[targetfolder])
    end
    print('')
end

-- Process all searchfolders
for i, sourcefolder in ipairs(searchfolders) do
    print('Processing search folder: ' .. sourcefolder .. '...')

    -- to_contains
    for j, pattern in ipairs(to_contains) do
        processMessages(sourcefolder, pattern, 'to_contains', targetfolder)
    end

    -- to_regex
    for j, pattern in ipairs(to_regex) do
        processMessages(sourcefolder, pattern, 'to_regex', targetfolder)
    end
end







